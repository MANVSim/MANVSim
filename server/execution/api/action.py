import uuid

from flask import Blueprint, request
from flask_jwt_extended import jwt_required
from werkzeug.exceptions import InternalServerError

from app_config import csrf
from execution.entities.performed_action import PerformedAction
from execution.entities.resource import Resource, try_lock_all, release_all_resources
from execution.utils import util
from execution.entities.action import Action
from utils import time
from event_logging.event import Event

api = Blueprint("api-action", __name__)


@api.get("/action/all")
@jwt_required()
def get_all_actions():
    """ Returns all actions stored for an execution. """
    execution, player = util.get_execution_and_player()
    # all actions a player can perform
    scenario_actions: list[Action] = list(execution.scenario.actions.values())
    player_role = player.role
    if not player_role:
        raise InternalServerError(f"Requesting player has no role assigned")

    actions = [action.to_dict() for action in scenario_actions
               if action.required_power <= player_role.power]
    return {"actions": actions}


@api.post("/action/perform")
@jwt_required()
@csrf.exempt
def perform_action():
    """
    Enqueues an action for a patient if:
        - the players role is allowed to perform the action
        - all resources required are provided
        - all resources are accessible
    As a result the method returns an id on which the result can be requested.
    """
    try:
        # Get request data
        execution, player = util.get_execution_and_player()
        form = request.get_json()
        action_id = int(form["action_id"])
        resource_ids_used = list(map(int, form["resources"]))
        patient_id = int(form["patient_id"])

        action = execution.scenario.actions[action_id]
        patient = execution.scenario.patients[patient_id]

        # check permission and parameters
        if not player.role or player.role.power < action.required_power:
            return "Missing right detected. You need a higher role to perform that action", 403

        if len(resource_ids_used) < len(action.resources_needed):
            return "Missmatch detected. Less resources used than required", 418

        # get objects from ids
        resources_used = {}
        for res_id in resource_ids_used:
            loc, res = player.location.get_resource_by_id(res_id) if player.location else (None, None)
            if res is None:
                return "Unable to identify resource. Please update your location-access.", 404
            if loc not in resources_used.keys():
                resources_used[loc] = [res]
            else:
                resources_used[loc].append(res)

        # Locking for edit
        resources_locked = []
        success = True
        for loc in resources_used.keys():
            if not loc.res_lock.locked():
                success = try_lock_all(resources_used[loc])
                if success:
                    resources_locked += resources_used[loc]
                else:
                    break
            else:
                success = False
                break

        if not success:
            release_all_resources(resources_locked)
            return "Unable to access runtime object. A timeout-error occurred.", 409

        # edit resources
        checklist: list = action.resources_needed[:]
        backup = []
        for res in resources_locked:
            if res.name not in checklist:
                continue

            checklist.remove(res.name)

            if not res.decrease(duration=action.duration_sec):
                rollback_quantity(backup)
                release_all_resources(resources_locked)  # release all locks after edit
                return "Resource is not available", 409

            backup.append(res)

        # release all locks after edit
        release_all_resources(resources_locked)

        if len(checklist) > 0:
            return "Missmatch detected. Less resources used than required", 418

        # store success

        start_time = time.current_time_s()

        Event.action_performed(execution_id=execution.id, time=start_time,
            player=player.tan, action=action.id, patient=patient_id, duration_s=action.duration_sec).log()

        performed_action = PerformedAction(str(uuid.uuid4()), start_time + action.duration_sec,
                                           execution.id, action, resources_locked, player.tan)
        patient.action_queue[performed_action.id] = performed_action
        return {"performed_action_id": performed_action.id}

    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.get("/action/perform/result")
@jwt_required()
def get_perform_action_result():
    """ Dequeues an action of a specific patient and applies the action to the patients' status. """
    execution, _ = util.get_execution_and_player()
    try:

        patient_id = int(request.args["patient_id"])
        perform_action_id = request.args["performed_action_id"]

        patient = execution.scenario.patients[patient_id]
        performed_action = patient.action_queue.pop(perform_action_id)
        result_keys = patient.apply_action(performed_action.action)
        patient.performed_actions.append(performed_action)
        # restore non-consumables
        for res in performed_action.resources_used:
            if not res.consumable:
                res.increase()

        return {
            "patient": patient.to_dict(),
            "conditions": patient.activity_diagram.current.get_conditions(result_keys)
        }

    except KeyError:
        return "Missing or invalid request parameter detected.", 400


# Helper
def rollback_quantity(backup: list[Resource]):
    """ Initiates an increase operation on every resource provided in the parameter. """
    for res in backup:
        res.increase(force=True)
