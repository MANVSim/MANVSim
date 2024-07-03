from flask import Blueprint, Response
from string_utils import booleanize
from werkzeug.exceptions import NotFound, BadRequest

from app_config import csrf
from execution import run
from execution.services import entityloader
from execution.utils.util import try_get_execution
from models import Execution
from utils.decorator import required, admin_only, RequiredValueSource

web_api = Blueprint("web_api-lobby", __name__)


@web_api.post("/scenario")
@required("id", int, RequiredValueSource.FORM)
@admin_only
def start_scenario(id: int):
    if entityloader.load_execution(id):
        return run.active_executions[id].to_dict()

    # Failure
    raise NotFound(f"Execution with id={id} does not exist")


@web_api.get("/execution/active")
def get_all_active_executions():
    """ Endpoint to return all currently active executions. """
    return {"active_executions": run.active_executions.values()}


@web_api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
@csrf.exempt
def get_execution_status(id: int):
    execution = try_get_execution(id)
    return execution.to_dict()


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
    player.alerted = not alerted
    return Response(status=200)
