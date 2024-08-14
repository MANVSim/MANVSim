from flask import Blueprint
import models


blueprint = Blueprint("patient", __name__)


@blueprint.get("/")
def get_patients():
    """
    Returns a list of patients with ID and name
    """
    return [
        {
            "id": patient.id,
            "name": patient.name,
        }
        for patient in models.Patient.query
    ]
