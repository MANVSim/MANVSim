from flask import Blueprint, request, Response
from flask_api import status
from flask_jwt_extended import jwt_required

from executions.utils import util

api = Blueprint("api-patient", __name__)


@api.get("/patient")
@jwt_required()
def get_patient():
    """
    Assigns the requesting player to the patients location and makes the players inventory accessible, iff the player
    has no current location assigned. Further it returns the updated player location and the patients' data.
    """
    try:
        execution, player = util.get_execution_and_player()
        patient_id = int(request.args["patient_id"])
        scenario = execution.scenario
        patient = scenario.patients[patient_id]

        if player.location is not None:
            return f"Player already set to another location: {player.location.id}", 405

        # Assign player to patient location
        player.location = patient.location

        player.location.add_locations(player.accessible_locations)

        return {
            "player_location": player.location.to_dict(),
            "patient": patient.to_dict(shallow=False)
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.get("/patient/all")
@jwt_required()
def get_all_patient():
    """ Returns all patients stored in the scenario. """
    try:
        execution, _ = util.get_execution_and_player()
        return {
            "patients": [patient.to_dict() for patient in list(execution.scenario.patients.values())]
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.get("/patient/leave")
@jwt_required()
def leave_patient_location():
    execution, player = util.get_execution_and_player()

    try:
        if player.location is None:
            return "Player is not assigned to any patient/location", 405

        player.location.leave_location(player.accessible_locations)

    except KeyError:
        return "Missing or invalid request parameter detected.", 400
    except TimeoutError:
        return "Unable to access runtime object. A timeout-error occurred.", 409
