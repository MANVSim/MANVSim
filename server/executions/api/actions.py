import uuid

from flask import Blueprint, request
from flask_jwt_extended import jwt_required

from executions.entities.performed_action import PerformedAction
from executions.entities.resource import Resource, try_lock_all, release_all
from executions.utils import util
from utils import time

api = Blueprint("api-action", __name__)


@api.get("/action/all")
@jwt_required()
def get_all_actions():
    """ Returns all actions stored for an execution. """
    execution, _ = util.get_execution_and_player()
    return {
        "actions": [action.to_dict() for action in list(execution.scenario.actions.values())]
    }


@api.post("/action/perform")
@jwt_required()
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
        action_id = int(request.form["action_id"])
        resource_ids_used = list(map(int, request.form["resources"]))
        patient_id = int(request.form["patient_id"])

        action = execution.scenario.actions[action_id]
        patient = execution.scenario.patients[patient_id]

        # check permission and parameters
        if player.role.power < action.required_power:
            return "Missing right detected. You need a higher role to perform that action", 403

        if len(resource_ids_used) < len(action.resources_needed):
            return "Missmatch detected. Less resources used than required", 418

        # get objects from ids
        resources_used = []
        for res_id in resource_ids_used:
            res = player.location.get_resource_by_id(res_id)
            if res is None:
                return "Resource not Found. Please update your location-access.", 404
            resources_used.append(res)

        # Locking for edit
        if not try_lock_all(resources_used):
            return "Unable to access runtime object. A timeout-error occurred.", 409

        checklist: list = action.resources_needed[:]
        backup = []
        for res in resources_used:
            if res.name not in checklist:
                continue

            checklist.remove(res.name)

            if not res.decrease(duration=action.duration_sec):
                rollback(backup)
                return "Resource is not available", 409

            backup.append(res)

        # release all locks after edit
        release_all(resources_used)

        if len(checklist) > 0:
            return "Missmatch detected. Less resources used than required", 418

        # store success
        performed_action = PerformedAction(str(uuid.uuid4()), time.current_time_s() + action.duration_sec,
                                           execution.id, action, resources_used, player.tan)
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
        patient.performed_actions.append(performed_action)

        # restore non-consumables
        for res in performed_action.resources_used:
            if not res.consumable:
                res.increase()

        patient.apply_action(performed_action.action)

        return {"patient": patient.to_dict()}

    except KeyError:
        return "Missing or invalid request parameter detected.", 400


# Helper
def rollback(backup: list[Resource]):
    """ Initiates an increase operation on every resource provided in the parameter. """
    for res in backup:
        res.increase(force=True)
