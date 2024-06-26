import json

from flask import Blueprint, Response, make_response, request
from flask_api import status
from flask_jwt_extended import create_access_token
from flask_login import login_user
from flask_wtf.csrf import CSRFError, generate_csrf
from werkzeug.exceptions import BadRequestKeyError, HTTPException, NotFound

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
def login():
    # Extract data from request
    try:
        username = request.form["username"]
        password = request.form["password"]
    except KeyError:
        return {
            "error": "Missing username or password in request"
        }, status.HTTP_400_BAD_REQUEST

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
    return [{"id": scenario.id, "name": scenario.name, "executions": [execution.id for execution in scenario.executions]}
            for scenario in models.Scenario.query]


@api.post("/scenario/start")
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


@api.post("/execution/start")
@required("id", int, RequiredValueSource.ARGS)
@admin_only
def start_execution(id: int):
    execution = try_get_execution(id)
    execution.status = Execution.Status.RUNNING
    return Response(status=200)


@api.post("/execution/stop")
@required("id", int, RequiredValueSource.ARGS)
@admin_only
def stop_execution(id: int):
    execution = try_get_execution(id)
    execution.status = Execution.Status.FINISHED
    return Response(status=200)


@api.post("/execution/player/status")
@required("id", int, RequiredValueSource.ARGS)
@required("tan", str, RequiredValueSource.ARGS)
# @admin_only
@csrf.exempt
def change_player_status(id: int, tan: str):
    try:
        status: bool = request.form["alerted"] == "1"
    except BadRequestKeyError:
        return {"error": "Missing 'alerted' attribute in request data"}, 400
    execution = try_get_execution(id)
    player = execution.players[tan]
    player.alerted = not status
    return Response(status=200)
