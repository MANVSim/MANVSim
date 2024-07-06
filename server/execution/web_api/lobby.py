import logging

from flask import Blueprint, Response, jsonify
from string_utils import booleanize
from werkzeug.exceptions import NotFound, BadRequest

import models
from app_config import csrf, db
from event_logging.event import Event
from execution import run
from execution.entities.execution import Execution
from execution.services import entityloader
from execution.utils.util import try_get_execution
from utils import time
from utils.decorator import required, admin_only, RequiredValueSource

web_api = Blueprint("web_api-lobby", __name__)


@web_api.post("/execution/activate")
@required("id", int, RequiredValueSource.FORM)
# @admin_only
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
def get_execution_status(id: int):
    print(id)
    execution = try_get_execution(id)
    return execution.to_dict()


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
            f"Not an option for the execution status: '{new_status}'. Possible values are: {str.join(", ", [e.name for e in Execution.Status])}")
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
