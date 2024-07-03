from flask import Blueprint, request
from flask_jwt_extended import jwt_required

from app_config import csrf
from execution.api.location import location_arrive
from execution.utils import util

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

        form["location_id"] = patient.location.id
        redirect = location_arrive()

        return {
            "player_location": (redirect["player_location"] if
                                isinstance(redirect, dict) else redirect),
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
