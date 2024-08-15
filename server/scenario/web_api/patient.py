from flask import Blueprint, Response
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


@blueprint.delete("<int:patient_id>")
def delete_patient(patient_id: int):
    """
    Deletes a patient by ID
    """
    models.Patient.query.filter_by(id=patient_id).delete()
    models.db.session.commit()
    return Response(status=200)


@blueprint.get("<int:patient_id>")
def get_patient(patient_id: int):
    """
    Returns a patient by ID
    """
    patient: models.Patient = models.Patient.query.get_or_404(patient_id)
    return {
        "id": patient.id,
        "name": patient.name,
        "activity_diagram": patient.activity_diagram,
    }
