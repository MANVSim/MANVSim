from flask import Blueprint, request
from flask_jwt_extended import jwt_required

from app_config import csrf
from execution.utils import util
from event_logging.event import Event
from utils import time

api = Blueprint("api-patient", __name__)


@api.post("/patient/arrive")
@jwt_required()
@csrf.exempt
def get_patient():
    """
    Assigns the requesting player to the patients location and makes the players
    inventory accessible, iff the player
    has no current location assigned. Further it returns the updated player
    location and the patients' data.
    """
    try:
        execution, player = util.get_execution_and_player()
        form = request.get_json()
        patient_id = int(form["patient_id"])
        scenario = execution.scenario
        patient = scenario.patients[patient_id]

        if player.location is not None:
            return (f"Player already set to another location: "
                    f"{player.location.id}"), 405

        player.location = patient.location
        player.location.add_locations(player.accessible_locations)

        Event.location_arrive(execution_id=execution.id,
                             time=time.current_time_s(),
                             player=player.tan, patient_id=patient.id).log()

        return {
            "player_location": player.location.to_dict(),
            "patient": patient.to_dict(shallow=False)
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.get("/patient/all-tans")
@jwt_required()
def get_all_patient():
    """ Returns all patients stored in the scenario. """
    try:
        execution, _ = util.get_execution_and_player()
        return {
            "tans": list(execution.scenario.patients.keys())
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
