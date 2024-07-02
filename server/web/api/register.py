import json
from itertools import groupby

from flask import Blueprint, Response, make_response
from flask_api import status
from flask_jwt_extended import create_access_token
from flask_login import login_user
from flask_wtf.csrf import CSRFError, generate_csrf
from werkzeug.exceptions import BadRequest, HTTPException, NotFound
from string_utils import booleanize

import models
from app_config import csrf
from execution.entities.execution import Execution
from execution.run import active_executions
from execution.services.entityloader import load_execution
from utils.flask import RequiredValueSource, admin_only, required, try_get_execution

# FIXME sollten wir zusammen mit dem Web package iwann mal umbenennen
api = Blueprint("api-web", __name__)


@api.errorhandler(HTTPException)
def http_exception_handler(e: HTTPException):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = make_response(e.get_response())
    # replace the body with JSON
    response.data = json.dumps({
        "error": e.description,
    })
    response.content_type = "application/json"
    return response


@api.errorhandler(CSRFError)
def handle_csrf_error(error: CSRFError):
    status = error.response or 400
    return make_response(({"error": error.description}, status))


@api.get("/csrf")
@csrf.exempt
def get_csrf():
    return {"csrf_token": generate_csrf()}


@api.post("/login")
@required("username", str, RequiredValueSource.FORM)
@required("password", str, RequiredValueSource.FORM)
def login(username: str, password: str):
    # Get user object from database
    user = models.WebUser.get_by_username(username)
    if user is None:
        return {
            "error": f"User with user name '{username}' does not exist"
        }, status.HTTP_401_UNAUTHORIZED

    # Check password
    if not user.check_password(password):
        return {"error": "Incorrect password"}, status.HTTP_401_UNAUTHORIZED

    login_user(user)
    return {"token": create_access_token(identity="admin"), "username": username}, 200


@api.get("/templates")
@admin_only
def get_templates():
    result = dict()

    def key_func(execution: Execution) -> int:
        return execution.scenario.id

    active = sorted(active_executions.values(), key=key_func)
    for scenario_id, execution_iterator in groupby(active, key=key_func):
        executions = list(execution_iterator)
        result[scenario_id] = {
            "name": executions[0].name,
            "executions": [execution.id for execution in executions]
        }

    for scenario in models.Scenario.query:
        executions = [e.id for e in scenario.executions]
        try:
            result[scenario.id]["executions"] += executions
        except KeyError:
            result[scenario.id] = {
                "name": scenario.name,
                "executions": executions
            }

    return [
        {
            "id": id,
            "name": x["name"],
            "executions": x["executions"]
        } for id, x in result.items()
    ]


@api.post("/scenario")
@required("id", int, RequiredValueSource.FORM)
@admin_only
def start_scenario(id: int):
    if load_execution(id):
        return active_executions[id].to_dict()

    # Failure
    raise NotFound(f"Execution with id={id} does not exist")


@api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
# @admin_only
@csrf.exempt
def get_execution_status(id: int):
    execution = try_get_execution(id)
    return execution.to_dict()


@api.patch("/execution")
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


@api.patch("/execution/player/status")
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


@api.post("/execution")
@required("id", int, RequiredValueSource.ARGS)
def add_new_player(id: int):
    execution = try_get_execution(id)
    # TODO: Create new player
    return Response(status=200)
