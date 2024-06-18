import datetime

from flask_jwt_extended import create_access_token, jwt_required
from flask_wtf.csrf import generate_csrf
from flask import request, Response
from flask_api import status
from flask import Blueprint

from app_config import csrf
from execution import run
from execution.utils import util

api = Blueprint("api-lobby", __name__)


@api.post("/login")
@csrf.exempt
def login():
    """
    Performs a login for a requesting TAN. If the TAN is registered to a registered execution, a JWT Token is generated,
    containing the related execution-id and player-TAN as identity.
    The method returns
     - JWT Token
     - CSRF Token (required for following POST request)
     - Boolean if player has no name yet
     - username
     - user-role
    """
    try:
        data = request.get_json()
        tan = data["TAN"]
        exec_id = run.registered_players[tan]
        player = run.active_executions[exec_id].players[tan]
        expires = datetime.timedelta(hours=12)
        additional_claims = {"exec_id": exec_id}
        access_token = create_access_token(identity=tan, expires_delta=expires, additional_claims=additional_claims)
        userCreationRequired = player.name is None or player.name == ""
        return {
            "jwt_token": access_token,
            "csrf_token": generate_csrf(),
            "user_creation_required": userCreationRequired,
            "user_name": "" if userCreationRequired else player.name,
            "user_role": (player.role if player.role is None else player.role.name)
        }
    except KeyError:
        return Response(response="Invalid TAN detected. Unable to resolve player.", status=status.HTTP_400_BAD_REQUEST)


@api.post("/player/set-name")
@jwt_required()
@csrf.exempt
def set_name():
    """ Changes the name of the requesting player. """
    try:
        form = request.get_json()
        name = form["name"]
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
    Method to request the start-time of the execution. It returns:
     - Code 400                         if TAN is invalid.
     - starting_time                    if the execution is running but the player has not been alerted yet.
     - starting_time & travel_time      if the execution is running but the player has been alerted.
    """
    try:
        execution, player = util.get_execution_and_player()

        if execution.status == execution.Status.PENDING:
            return Response(response="The execution has not been started yet", status=status.HTTP_204_NO_CONTENT)
        elif execution.status == execution.Status.RUNNING and not player.alerted:
            return {
                "starting_time": execution.starting_time,
            }
        else:
            return {
                "starting_time": execution.starting_time,
                "travel_time": player.activation_delay_sec
            }
    except KeyError:
        return Response(
            response="Invalid execution id or TAN provided. Unable to resolve data.",
            status=status.HTTP_400_BAD_REQUEST,
        )
