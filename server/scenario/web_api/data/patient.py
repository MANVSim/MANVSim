from flask import Blueprint, Response

import models
from utils.decorator import role_required

web_api = Blueprint("web_api-patient", __name__)


@web_api.get("/patient/all")
# @role_required(models.WebUser.Role.READ_ONLY)
def get_all_patients():
    """ Returns a json of all locations stored. """
    patient_list = models.Patient.query.all()
    return [
        {
            "id": patient.id,
            "name": patient.template_name,
        } for patient in patient_list
    ]


@web_api.delete("/patient/<int:patient_id>")
def delete_patient(patient_id: int):
    """
    Deletes a patient by ID
    """
    models.Patient.query.filter_by(id=patient_id).delete()
    models.db.session.commit()
    return Response(status=200)


@web_api.get("/patient/<int:patient_id>")
def get_patient(patient_id: int):
    """
    Returns a patient by ID
    """
    patient: models.Patient = models.Patient.query.get_or_404(patient_id)
    return {
        "id": patient.id,
        "name": patient.template_name,
        "activity_diagram": patient.activity_diagram,
    }
