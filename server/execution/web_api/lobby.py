from typing import List
import logging

from flask import Blueprint, Response, jsonify
from string_utils import booleanize
from werkzeug.exceptions import NotFound, BadRequest, InternalServerError

import models
from app_config import csrf, db
from event_logging.event import Event
from execution import run
from execution.entities.execution import Execution
from execution.services.entityloader import load_execution
from execution.utils.util import try_get_execution
from utils import time
from utils.decorator import required, admin_only, RequiredValueSource, cache

web_api = Blueprint("web_api-lobby", __name__)


@web_api.post("/execution/activate")
@required("id", int, RequiredValueSource.FORM)
# @admin_only //FIXME enable me as soon as role management is working
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
    return [execution.to_dict() for execution
            in run.active_executions.values()]


@web_api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
@admin_only
def get_execution_status(id: int):
    # Add the execution to the active executions in case it stems from the
    # database
    try:
        execution = run.active_executions[id]
    except KeyError:
        if load_execution(id):
            execution = run.active_executions[id]
        else:
            raise InternalServerError(
                f"Could not activate execution with id {id}")

    return {
        "status": execution.status.value,
        "players": [{
            "tan": player.tan,
            "name": player.name,
            "alerted": player.alerted,
            "logged_in": player.logged_in,
            "role": {"id": player.role.id, "name": player.role.name} if player.role else None,
            "location": {"id": player.location.id, "name": player.location.name} if player.location else None
        } for player in execution.players.values()],
        "roles": [{
            "id": x.id,
            "name": x.name
        } for x in __get_roles()],
        "locations": [{
            "id": x.id,
            "name": x.name
        } for x in __get_top_level_locations()]
    }


@web_api.post("/execution")
@required("scenario_id", int, RequiredValueSource.FORM)
@required("name", str, RequiredValueSource.FORM)
def create_execution(scenario_id: int, name: str):
    try:
        new_execution = models.Execution(scenario_id=scenario_id, name=name)
        db.session.add(new_execution)
        db.session.commit()
        print(f"new execution created with id: {new_execution.id}")
        return {"id": new_execution.id}, 201
    except Exception:
        message = ("Unable to save execution. "
                   "Possibly invalid parameter provided")
        logging.error(message)
        return message, 400


@web_api.patch("/execution")
@required("id", int, RequiredValueSource.ARGS)
@required("new_status", str.upper, RequiredValueSource.FORM)
@admin_only
def change_execution_status(id: int, new_status: str):
    execution = try_get_execution(id)
    try:
        execution.status = Execution.Status[new_status]
    except KeyError:
        raise BadRequest(
            f"Not an option for the execution status: '{new_status}'. "
            f"Possible values are: "
            f"{str.join(', ', [e.name for e in Execution.Status])}")
    return Response(status=200)


@web_api.patch("/execution/player/status")
@required("id", int, RequiredValueSource.ARGS)
@required("tan", str, RequiredValueSource.ARGS)
@required("alerted", booleanize, RequiredValueSource.FORM)
@admin_only
def change_player_status(id: int, tan: str, alerted: bool):
    execution = try_get_execution(id)
    try:
        player = execution.players[tan]
    except KeyError:
        raise NotFound(
            f"Player with TAN '{tan}' does not exist for execution with id {id}")
    if alerted:
        Event.player_alerted(execution_id=execution.id,
                             time=time.current_time_s(),
                             player=player.tan).log()
    player.alerted = not alerted
    return Response(status=200)


@web_api.post("/execution")
@required("id", int, RequiredValueSource.ARGS)
@required("role", int, RequiredValueSource.FORM)
@required("location", int, RequiredValueSource.FORM)
def add_new_player(id: int, role: int, location: int):
    execution = try_get_execution(id)
    execution.add_new_player(role, location)
    return Response(status=200)


@cache
def __get_roles() -> List[models.Role]:
    """
    Gets all roles currently stored in the database. For efficient access the
    result is cached for subsequent function calls as the DB is not expected to
    change during

    :return: List of roles
    """
    return models.Role.query.all()


@cache
def __get_top_level_locations() -> List[models.Location]:
    return models.Location.query.where(models.Location.location_id.is_(None)).all()
