from functools import wraps
import math
from random import random, choice
from flask import abort, make_response, request, Blueprint
from flask_api import status
from flask_jwt_extended import create_access_token, get_jwt_identity, jwt_required
from flask_login import login_user
from flask_wtf.csrf import CSRFError, generate_csrf
from models import WebUser
from app_config import csrf
from .test_data import test_execution

# FIXME sollten wir zusammen mit dem Web package iwann mal umbenennen
api = Blueprint("api-web", __name__)


@api.errorhandler(CSRFError)
def handle_csrf_error(error: CSRFError):
    status = error.response or 400
    return make_response(({"error": error.description}, status))


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
@csrf.exempt  # TODO: Remove
def get_csrf():
    return {"csrf_token": generate_csrf()}


@api.post("/login")
@csrf.exempt  # TODO: Remove
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
    user = WebUser.get_by_username(username)
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
    return [
        {"id": 10023, "name": "Busunfall", "players": 5},
        {"id": 900323, "name": "Explosion im Wohnviertel", "players": 10},
    ]


@api.post("/scenario/start")
@admin_only
def start_scenario():
    try:
        id = request.form["id"]
        # TODO: Create actual execution
        return {
            "id": math.floor(random() * 1000),
        }
    except KeyError:
        return {"error": "Missing id in request"}, 400


@api.get("/execution/<int:id>")
@admin_only
def get_execution_status(id: int):
    test_execution["id"] = id
    random_player = choice(test_execution["players"])
    random_player["status"] = "In Vorbereitung" if random_player["status"] == "" else ""
    return test_execution


@api.post("/execution/<int:id>/start")
@admin_only
def start_execution(id: int):
    test_execution["status"] = "Aktiv"
    return test_execution


@api.post("/execution/<int:id>/stop")
@admin_only
def stop_execution(id: int):
    test_execution["status"] = ""
    return test_execution
