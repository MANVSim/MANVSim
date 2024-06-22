from functools import wraps
from flask import abort, make_response, request, Blueprint
from flask_api import status
from flask_jwt_extended import create_access_token, get_jwt_identity, jwt_required
from flask_login import login_user
from flask_wtf.csrf import CSRFError, generate_csrf
from execution.entities.execution import Execution
from execution.tests.entities.dummy_entities import create_test_execution
import models
from app_config import csrf
from execution.run import activate_execution, active_executions

# FIXME sollten wir zusammen mit dem Web package iwann mal umbenennen
api = Blueprint("api-web", __name__)


class ExecutionIdNotFound(Exception):
    status_code = 404
    execution_id: int

    def __init__(self, id: int) -> None:
        super().__init__()
        self.execution_id = id

    def to_dict(self):
        return {
            "error": f"The given execution with id {self.execution_id} does not exist"
        }


@api.errorhandler(ExecutionIdNotFound)
def execution_not_found(e: ExecutionIdNotFound):
    return e.to_dict(), e.status_code


@api.errorhandler(CSRFError)
def handle_csrf_error(error: CSRFError):
    status = error.response or 400
    return make_response(({"error": error.description}, status))


def try_get_execution(id: int):
    try:
        execution = active_executions[id]
    except KeyError:
        raise ExecutionIdNotFound(id)

    return execution


def admin_only(func):
    @wraps(func)  # https://stackoverflow.com/a/64534085/11370741
    @jwt_required()
    def wrapper(*args, **kwargs):
        identity = get_jwt_identity()
        if identity != "admin":
            abort(status.HTTP_401_UNAUTHORIZED)
        return func(*args, **kwargs)

    return wrapper


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
# @admin_only
@csrf.exempt
def start_scenario():
    try:
        id = int(request.form["id"])
    except KeyError:
        return {"error": "Missing id in request"}, 400

    execution = models.Execution.query.get(id)
    if execution is None:
        return {"error": f"Could not find execution with id {id}"}

    run_execution = create_test_execution()
    run_execution.id = id
    activate_execution(run_execution)
    return run_execution.to_dict()


@api.get("/execution/<int:id>")
@admin_only
def get_execution_status(id: int):
    execution = try_get_execution(id)
    return execution.to_dict()


@api.post("/execution/<int:id>/start")
@admin_only
def start_execution(id: int):
    execution = try_get_execution(id)
    execution.status = Execution.Status.RUNNING
    return execution.to_dict()


@api.post("/execution/<int:id>/stop")
@admin_only
def stop_execution(id: int):
    execution = try_get_execution(id)
    execution.status = Execution.Status.FINISHED
    return execution.to_dict()
