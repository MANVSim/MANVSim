import datetime

from flask_jwt_extended import create_access_token, jwt_required
from flask_wtf.csrf import generate_csrf
from flask import request, Response
from flask_api import status
from flask import Blueprint

from app_config import csrf
from execution import run
from execution.utils import util
from vars import ACQUIRE_TIMEOUT

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
        return "Invalid TAN detected. Unable to resolve player.", 400


@api.post("/player/set-name")
@jwt_required()
@csrf.exempt
def set_name():
    """ Changes the name of the requesting player. """
    try:
        form = request.get_json()
        name = form["name"]
        force_update = form["force_update"] == "True" if "force_update" in form.keys() else False
        _, player = util.get_execution_and_player()
        with player.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT):
            if not player.name or force_update:
                player.name = name
            else:
                return "A player-name is already set", 409

        return "Name successfully set.", 200
    except KeyError:
        return "Invalid form detected. Unable to resolve attribute 'name'.", 400


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
        return "Invalid execution id or TAN provided. Unable to resolve data.", 400
