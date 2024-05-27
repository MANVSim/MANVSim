import datetime
import logging

from flask_jwt_extended import create_access_token, jwt_required
from flask_wtf.csrf import generate_csrf
from flask import request, Response
from flask_api import status
from flask import Blueprint

from app import csrf
from executions import run, util

api = Blueprint("api-lobby", __name__)


@api.post("/login")
@csrf.exempt
def login():
    try:
        tan = request.form["TAN"]
        exec_id = run.registered_player[tan]
        player = run.exec_dict[exec_id].get_player_by_tan(tan)
        expires = datetime.timedelta(hours=12)
        additional_claims = {"exec_id": exec_id, "TAN": tan}
        access_token = create_access_token(identity=tan, expires_delta=expires, additional_claims=additional_claims)
        userCreationRequired = player.name is None or player.name == ""
        return {
            "jwt_token": access_token,
            "csrf_token": generate_csrf(),
            "userCreationRequired": userCreationRequired,
            "userName": "" if userCreationRequired else player.name,
            "userRole": "Sani"  # FIXME when roles are implemented
        }
    except KeyError:
        return Response(response="Invalid TAN detected. Unable to resolve player.", status=status.HTTP_400_BAD_REQUEST)


@api.post("/player/set-name")
@jwt_required()
def set_name():
    try:
        name = request.form["name"]
        _, player = util.get_execution_and_player()
        player.name = name
        return Response(response="Name successfully set.", status=status.HTTP_200_OK)
    except KeyError:
        return Response(
            response="Invalid form detected. Unable to resolve attribute 'name'.",
            status=status.HTTP_400_BAD_REQUEST
        )


@api.get("/scenario/start-time")
@jwt_required()
def get_current_exec_status():
    """
    A method to check on the current status. If the execution is set to status running the response contains
    a scenario id and name to continue further progress. Otherwise, only the current status
    """
    try:
        execution, player = util.get_execution_and_player()

        if execution.status == execution.Status.PENDING:
            return Response(response="The execution has not been started yet", status=status.HTTP_204_NO_CONTENT)
        elif (execution.status == execution.Status.RUNNING
              and player is None):  # FIXME use player status to send inactive infos
            return {
                "starting_time": execution.starting_time,
            }
        else:
            return {
                "starting_time": execution.starting_time,
                "travel_time": 60000  # FIXME use arrival time set for player specificly.
            }
    except KeyError:
        return Response(
            response="Invalid execution id or TAN provided. Unable to resolve data.",
            status=status.HTTP_400_BAD_REQUEST,
        )
