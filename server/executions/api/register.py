import datetime
import logging

from flask_jwt_extended import create_access_token, jwt_required
from flask_wtf.csrf import generate_csrf

from app import csrf
from executions import run, util

from flask import request, Response
from flask_api import status

from flask import Blueprint

api = Blueprint("api-register", __name__)


@api.get("/exec/status/")
@jwt_required()
def get_current_exec_status():
    """
    A method to check on the current status. If the execution is set to status running the response contains
    a scenario id and name to continue further progress. Otherwise, only the current status
    """
    try:
        exec_id = util.get_param_from_jwt("exec_id")
        execution = run.exec_dict[exec_id]
        if execution.status == execution.Status.RUNNING:
            return {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time,
                "scenario": {
                    "scn_id": execution.scenario.id,
                    "scn_name": execution.scenario.name,
                },
            }
        else:
            return {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time,
            }
    except KeyError:
        return Response(
            response="Invalid execution id provided. Unable to resolve execution data.",
            status=status.HTTP_400_BAD_REQUEST,
        )


@api.get("/register/hello")
@jwt_required()
def hello_world():
    return {"hello": "world"}


@api.post("/login")
@csrf.exempt
def register_player():
    try:
        tan = request.form["TAN"]
        exec_id = run.active_player[tan]
        expires = datetime.timedelta(hours=12)
        additional_claims = {"exec_id": exec_id, "TAN": tan}
        access_token = create_access_token(identity=tan, expires_delta=expires, additional_claims=additional_claims)
        return {
            "jwt_token": access_token,
            "csrf_token": generate_csrf()
        }
    except KeyError:
        logging.error("invalid tan detected. Unable to resolve player.")
        return Response(response="Invalid TAN detected. Unable to resolve player.",
                        status=status.HTTP_400_BAD_REQUEST)
