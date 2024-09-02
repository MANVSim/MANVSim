from flask import Blueprint

import models
from utils.decorator import role_required

web_api = Blueprint("web_api-patient", __name__)


@web_api.get("/patient/all")
@role_required(models.WebUser.Role.READ_ONLY)
def get_all_patients():
    """ Returns a json of all locations stored. """
    patient_list = models.Patient.query.all()
    return [
        {
            "id": patient.id,
            "name": patient.template_name,
        } for patient in patient_list
    ]
