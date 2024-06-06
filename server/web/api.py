import math
from random import random

from flask import make_response, request
from flask_api import status
from flask_wtf.csrf import CSRFError, generate_csrf
from tans.tans import uniques

from . import web_blueprint


@web_blueprint.errorhandler(CSRFError)
def handle_csrf_error(error: CSRFError):
    status = error.response or 400
    return make_response(({"error": error.description}, status))


@web_blueprint.get("/templates")
def get_templates():
    return [
        {"id": 10023, "name": "Busunfall", "players": 5},
        {"id": 900323, "name": "Explosion im Wohnviertel", "players": 10},
    ]


@web_blueprint.post("/scenario/start")
def start_scenario():
    try:
        id = request.form["id"]
    except KeyError:
        return {"error": "Missing id in request"}, 400
    # TODO: Create actual execution
    return {
        "id": math.floor(random() * 1000),
        "tans": [str(x) for x in uniques(10)],
    }


@web_blueprint.post("/login")
def login():
    try:
        username = request.form["username"]
        password = request.form["password"]
    except KeyError:
        return {
            "error": "Missing username or password in request"
        }, status.HTTP_400_BAD_REQUEST
    return {"token": "randomtokenname"}


@web_blueprint.get("/csrf")
def get_csrf():
    return {"csrf_token": generate_csrf()}
