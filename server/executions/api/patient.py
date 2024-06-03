from flask import Blueprint, request, Response
from flask_api import status
from flask_jwt_extended import jwt_required

from executions.utils import util

api = Blueprint("api-patient", __name__)


@api.get("/patient")
@jwt_required()
def get_patient():
    """
    Assigns the requesting player to the patients location and makes the players inventory accessible. Further it
    returns the updated player location and the patients' data.
    """
    try:
        execution, player = util.get_execution_and_player()
        patient_id = int(request.args["patient_id"])
        scenario = execution.scenario
        patient = scenario.patients[patient_id]

        # TODO aktives leaven oder inaktives leaven

        # Assign player to patient location
        player.location = patient.location

        player.location.add_locations(player.accessible_locations)

        return {
            "player_location": player.location.to_dict(),
            "patient": patient.to_json(shallow=False)
        }
    except KeyError:
        return Response(response="Invalid parameter or parameter set. Unable to resolve patient.",
                        status=status.HTTP_400_BAD_REQUEST)


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
        return f"Missing or invalid request parameter detected.", 400
