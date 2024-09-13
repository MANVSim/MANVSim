import logging
from typing import List

from flask import Blueprint, Response
from string_utils import booleanize
from werkzeug.exceptions import NotFound, BadRequest, InternalServerError

import models
from app_config import csrf, db
from execution.entities.event import Event
from execution import run
from execution.entities.execution import Execution
from execution.services import entityloader
from execution.utils.util import try_get_execution
from utils.decorator import required, RequiredValueSource, cache

web_api = Blueprint("web_api-lobby", __name__)


@web_api.post("/execution/activate")
@required("id", int, RequiredValueSource.FORM)
@csrf.exempt
def activate_execution(id: int):
    if id in run.active_executions.keys():
        return run.active_executions[id].to_dict(), 200
    if entityloader.load_execution(id):
        return run.active_executions[id].to_dict(), 201

    # Failure
    raise NotFound(f"Execution with id={id} does not exist")


@web_api.get("/execution/active")
def get_all_active_executions():
    """ Endpoint to return all currently active executions. """
    return [execution.to_dict(shallow=True) for execution
            in run.active_executions.values()]


@web_api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
def get_execution(id: int):
    # Add the execution to the active executions in case it stems from the
    # database
    if id in run.active_executions.keys():
        execution = run.active_executions[id]
    else:
        execution: bool | Execution = entityloader.load_execution(id,
                                                                  save_in_memory=False)

    if isinstance(execution, bool) and not execution:
        raise NotFound(f"Execution with id={id} does not exist")
    elif isinstance(execution, bool) and execution:
        raise InternalServerError("Execution found but invalid return type "
                                  "provided.")
    else:
        return {
            "id": execution.id,
            "name": execution.name,
            "status": execution.status.name,
            "players": [{
                "tan": player.tan,
                "name": player.name,
                "alerted": player.alerted,
                "logged_in": player.logged_in,
                "role": player.role.to_dict(
                    include=["id", "name"]) if player.role else None,
                "location": player.location.to_dict(
                    include=["id", "name"]) if player.location else None
            } for player in execution.players.values()],
            "roles": [{
                "id": x.id,
                "name": x.name
            } for x in __get_roles()],
            "locations": [{
                "id": x.location_id,
                "name": x.vehicle_name
            } for x in __get_top_level_locations(execution.id)],
            "notifications": execution.notifications
        }


@web_api.post("/execution/create")
@required("scenario_id", int, RequiredValueSource.FORM)
@required("name", str, RequiredValueSource.FORM)
def create_execution(scenario_id: int, name: str):

    # TODO implement validator to prevent empty scenarios
    try:
        new_execution = models.Execution(scenario_id=scenario_id, name=name)  # type: ignore
        db.session.add(new_execution)
        db.session.commit()

        # Case: first execution of scenario -> reassign wildcard entries in PlayersToVehicle
        vehicle_list = models.PlayersToVehicleInExecution.query.filter_by(
            execution_id=0,  # wildcard id
            scenario_id=scenario_id
        ).all()
        for vehicle in vehicle_list:
            vehicle.execution_id = new_execution.id

        db.session.commit()
        logging.info(f"new execution created with id: {new_execution.id}")
        return {"id": new_execution.id}, 201
    except Exception:
        message = ("Unable to save execution. "
                   "Possibly invalid parameter provided")
        logging.error(message)
        return message, 400


@web_api.patch("/execution")
@required("id", int, RequiredValueSource.ARGS)
@required("new_status", str.upper, RequiredValueSource.FORM)
@csrf.exempt  # changes are applied via buttons. Therefore, no CSRF required
def change_execution_status(id: int, new_status: str):
    execution = try_get_execution(id)
    try:
        new_status_enum = Execution.Status[new_status]
        __perform_state_change(new_status_enum, execution)
        execution.status = new_status_enum
        return Response(status=200)

    except KeyError:
        raise BadRequest(f"Not an option for the execution status: "
                         f"'{new_status}'. ")


@web_api.patch("/execution/player/status")
@required("id", int, RequiredValueSource.ARGS)
@required("tan", str, RequiredValueSource.ARGS)
@required("alerted", booleanize, RequiredValueSource.FORM)
def change_player_status(id: int, tan: str, alerted: bool):
    execution = try_get_execution(id)
    try:
        player = execution.players[tan]
    except KeyError:
        raise NotFound(
            f"Player with TAN '{tan}' does not exist for execution with id {id}")
    if alerted:
        player.alert()
        Event.player_alerted(execution_id=execution.id,
                             time=player.alerted_timestamp,
                             player=player.tan).log()
    else:
        player.remove_alert()

    return Response(status=200)


@web_api.post("/execution")
@required("id", int, RequiredValueSource.ARGS)
@required("role", int, RequiredValueSource.FORM)
@required("vehicle", str, RequiredValueSource.FORM)
def add_new_player(id: int, role: int, vehicle: str):
    execution = try_get_execution(id)
    execution.add_new_player(role, vehicle)
    return Response(status=200)


@cache
def __get_roles() -> list[models.Role]:
    """
    Gets all roles currently stored in the database. For efficient access the
    result is cached for subsequent function calls as the DB is not expected to
    change during

    :return: List of roles
    """
    return models.Role.query.all()


@cache
def __get_top_level_locations(execution_id: int) -> List[models.Location]:
    return (models.PlayersToVehicleInExecution.query
            .filter_by(execution_id=execution_id)
            .group_by(models.PlayersToVehicleInExecution.vehicle_name)
            .all())


def __perform_state_change(new_status: Execution.Status, execution: Execution):
    # current status
    match execution.status:
        case Execution.Status.PENDING:
            if new_status is Execution.Status.RUNNING:
                execution.start_execution()
            elif new_status is Execution.Status.UNKNOWN:
                run.deactivate_execution(execution.id)
            elif new_status is Execution.Status.PENDING:
                return
            else:
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.RUNNING:
            if new_status is Execution.Status.PENDING:
                execution.pause_execution()
            elif new_status is Execution.Status.FINISHED:
                execution.archive()
                run.deactivate_execution(execution.id)
            elif new_status is Execution.Status.RUNNING:
                return
            else:
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.FINISHED:
            if new_status is Execution.Status.FINISHED:
                return
            else:
                # no repetition allowed at this point.
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.UNKNOWN:
            if new_status is Execution.Status.PENDING:
                return
            else:
                # indicates no registration of execution. Status is set by
                # activating the execution
                raise BadRequest("Process manipulation detected. "
                                "Invalid State change")
