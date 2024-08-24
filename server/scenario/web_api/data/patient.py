from flask import Blueprint

import models

web_api = Blueprint("web_api-patient", __name__)


@web_api.get("/location/all")
def get_all_patients():
    """ Returns a json of all locations stored. """
    patient_list = models.Patient.query.all()
    return [
        {
            "id": patient.id,
            "name": patient.name,
        } for patient in patient_list
    ]