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
from app_config import csrf, db
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
    class IntermediateResult:
        name: str
        executions: set[int]

        def __init__(self, name: str, executions: set[int]) -> None:
            self.name = name
            self.executions = executions

    result: dict[int, IntermediateResult] = dict()

    def key_func(execution: Execution) -> int:
        return execution.scenario.id

    active = sorted(active_executions.values(), key=key_func)
    for scenario_id, execution_iterator in groupby(active, key=key_func):
        executions = list(execution_iterator)
        result[scenario_id] = IntermediateResult(
            executions[0].name, set(execution.id for execution in executions))

    # for scenario in models.Scenario.query:
    #     executions = set(e.id for e in scenario.executions)
    #     try:
    #         result[scenario.id].executions.update(executions)
    #     except KeyError:
    #         result[scenario.id] = IntermediateResult(scenario.name, executions)

    return [
        {
            "id": id,
            "name": x.name,
            "executions": list(x.executions)
        } for id, x in result.items()
    ]


@api.post("/scenario")
@required("id", int, RequiredValueSource.FORM)
@admin_only
def start_scenario(id: int):
    scenario: models.Scenario = models.Scenario.query.get_or_404(
        id, f"The Scenario with id {id} does not exist")

    execution = models.Execution(
        scenario_id=scenario.id, name="")  # type: ignore
    db.session.add(execution)
    db.session.commit()
    if not load_execution(execution.id):
        return {"error": f"Could not load execution {execution.id}"}, 500
    return {"id": execution.id}


@api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
@admin_only
def get_execution_status(id: int):
    execution = try_get_execution(id)
    return {
        "status": execution.status.value,
        "players": [{
            "tan": player.tan,
            "name": player.name,
            "alerted": player.alerted,
            "logged_in": player.logged_in
        } for player in execution.players.values()],
        "roles": [{
            "id": x.id,
            "name": x.name
        } for x in models.Role.query],  # TODO: Don't use DB
        "locations": [{
            "id": x.id,
            "name": x.name
        } for x in models.Location.query.where(models.Location.location_id.is_(None))]
    }


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
@required("role", int, RequiredValueSource.FORM)
@required("location", int, RequiredValueSource.FORM)
def add_new_player(id: int, role: int, location: int):
    execution = try_get_execution(id)
    execution.add_new_player(role, location)
    return Response(status=200)
