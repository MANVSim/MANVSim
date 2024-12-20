import json
from flask import Blueprint, Response, request

import models
from utils.decorator import role_required

web_api = Blueprint("web_api-patient", __name__)


@web_api.get("/patient/all")
# @role_required(models.WebUser.Role.READ_ONLY)
def get_all_patients():
    """Returns a json of all locations stored."""
    patient_list = models.Patient.query.all()
    return [
        {
            "id": patient.id,
            "name": patient.template_name,
        }
        for patient in patient_list
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
    activity_diagram = json.loads(patient.activity_diagram)
    # Only use the UUID of the current state
    try:
        activity_diagram["current"] = activity_diagram["current"]["uuid"]
    except KeyError:
        activity_diagram["current"] = ""

    return {
        "id": patient.id,
        "name": patient.template_name,
        "activity_diagram": activity_diagram,
    }


@web_api.put("/patient/<int:patient_id>")
def update_patient(patient_id: int):
    """
    Updates a patient by ID
    """
    content = request.json
    if content is None:
        return {"error": "No JSON body provided"}, 400
    patient: models.Patient = models.Patient.query.get_or_404(patient_id)
    # Convert the UUID of the current state to the full state as it is required
    # by the format
    try:
        activity_diagram = content["activity_diagram"]
    except KeyError:
        return {"error": "Invalid JSON body. Missing activity_diagram."}, 400

    try:
        activity_diagram["current"] = activity_diagram["states"][
            activity_diagram["current"]
        ]
    except KeyError:
        activity_diagram["current"] = None

    patient.activity_diagram = json.dumps(content["activity_diagram"])
    patient.template_name = content["name"]
    models.db.session.commit()
    return Response(status=200)
