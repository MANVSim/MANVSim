import math
from random import random

from flask import make_response, request, Blueprint
from flask_api import status
from flask_wtf.csrf import CSRFError, generate_csrf
from tans.tans import uniques

api = Blueprint("api-web", __name__)  # FIXME sollten wir zusammen mit dem Web package iwann mal umbenennen


@api.errorhandler(CSRFError)
def handle_csrf_error(error: CSRFError):
    status = error.response or 400
    return make_response(({"error": error.description}, status))


@api.get("/templates")
def get_templates():
    return [
        {"id": 10023, "name": "Busunfall", "players": 5},
        {"id": 900323, "name": "Explosion im Wohnviertel", "players": 10},
    ]


@api.post("/scenario/start")
def start_scenario():
    try:
        id = request.form["id"]
        # TODO: Create actual execution
        return {
            "id": math.floor(random() * 1000),
            "tans": [str(x) for x in uniques(10)],
        }
    except KeyError:
        return {"error": "Missing id in request"}, 400


@api.post("/login")
def login():
    try:
        username = request.form["username"]
        password = request.form["password"]

        return {"token": "randomtokenname"}

    except KeyError:
        return {
            "error": "Missing username or password in request"
        }, status.HTTP_400_BAD_REQUEST


@api.get("/csrf")
def get_csrf():
    return {"csrf_token": generate_csrf()}
