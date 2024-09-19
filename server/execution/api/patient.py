from flask import Blueprint
from flask_jwt_extended import jwt_required

from app_config import csrf
from execution.entities.patient import Patient
from execution.utils import util
from execution.entities.event import Event
from utils import time
from utils.decorator import required, RequiredValueSource

api = Blueprint("api-patient", __name__)


@api.post("/patient/arrive")
@jwt_required()
@required("patient_id", int, RequiredValueSource.JSON)
@csrf.exempt
def get_patient(patient_id: int):
    """
    Assigns the requesting player to the patients location and makes the players
    inventory accessible, iff the player
    has no current location assigned. Further it returns the updated player
    location and the patients' data.
    """
    try:
        execution, player = util.get_execution_and_player()
        scenario = execution.scenario
        patient = scenario.patients[patient_id]

        if player.location is not None:
            return (f"Player already set to another location: "
                    f"{player.location.id}"), 405

        player.location = patient.location
        player.location.add_locations(player.accessible_locations)

        Event.patient_arrive(execution_id=execution.id, time=time.current_time_s(),
                             player=player.tan, patient_id=patient.id).log()

        return {
            "player_location": player.location.to_dict(),
            "patient": patient.to_dict(shallow=False)
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.patch("patient/classify")
@required("patient_id", int, RequiredValueSource.JSON)
@required("classification", str, RequiredValueSource.JSON)
@jwt_required()
@csrf.exempt
def classify_patient(patient_id: int, classification: str):
    try:
        execution, player = util.get_execution_and_player()
        patient = execution.scenario.patients[patient_id]
        classification_enum: Patient.Classification = (Patient.Classification
                                                  .from_string(classification))
        patient.classification = classification_enum

        Event.patient_classify(execution_id=execution.id,
                               time=time.current_time_s(),
                               player=player.tan,
                               patient_id=patient.id,
                               classification=classification_enum.name)

        return "Successfully updated patient.", 200

    except ValueError:
        return "Missing or invalid request parameter 'classification' detected.", 400
    except KeyError:
        return "Missing or invalid request parameter detected.", 400


@api.get("/patient/all-ids")
@jwt_required()
def get_all_patient():
    """ Returns all patients stored in the scenario. """
    try:
        execution, _ = util.get_execution_and_player()
        patient_ids = list(execution.scenario.patients.keys())
        return {
            "patient_ids": patient_ids,
            "patient_names": [execution.scenario.patients[patient_id].name for
                              patient_id in patient_ids]
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
