import logging

from flask import Blueprint, request
from werkzeug.exceptions import NotFound, BadRequest

import models
from models import WebUser
from app_config import db
from utils.decorator import role_required, required, RequiredValueSource

web_api = Blueprint("web_api-scenario", __name__)

# pyright: reportCallIssue=false
# pyright: reportAttributeAccessIssue=false
# The following statements are excluded from pyright, due to ORM specifics.


# -- DBO Execution

@web_api.get("/templates")
@role_required(WebUser.Role.READ_ONLY)
def get_templates():
    return [
        {
            "id": scenario.id,
            "name": scenario.name,
            "executions": [
                {"id": execution.id, "name": execution.name}
                for execution in scenario.executions
            ]
        }
        for scenario in models.Scenario.query
    ]


# -- DBO Scenario

@web_api.get("/scenario")
@required("scenario_id", int, RequiredValueSource.ARGS)
def get_scenario(scenario_id: int):
    """
    Returns data of a scenario dbo related to the provided id.
    """
    scenario = models.Scenario.query.filter_by(id=scenario_id).first()

    if not scenario:
        raise NotFound(f"scenario not found by id={scenario_id}")

    patient_list = models.PatientInScenario.query.filter_by(
        scenario_id=scenario_id
    )

    vehicle_list = (models.Location.query.join(
        models.PlayersToVehicleInExecution,
        models.Location.id == models.PlayersToVehicleInExecution.location_id
    ).filter(
        models.PlayersToVehicleInExecution.scenario_id == scenario_id
    ).all())

    return {
        "id": scenario.id,
        "name": scenario.name,
        "patients": [
            {
                "id": patient.patient_id,
                "name": patient.name
            }
            for patient in patient_list
        ],
        "vehicles": [
            {
                "id": vehicle.id,
                "name": vehicle.name,
            } for vehicle in vehicle_list
        ]
    }


@web_api.post("/scenario")
def create_scenario():
    """ Creates an empty scenario dbo. """
    scenario = models.Scenario(name="Neues Scenario")
    db.session.add(scenario)
    db.session.commit()

    return {
        "id": scenario.id,
        "name": scenario.name,
        "patients": [],
        "vehicles": []
    }


@web_api.patch("/scenario")
@required("id", int, RequiredValueSource.JSON)
def edit_scenario(id: int):
    """
    Endpoint to update an existing scenario. If the related keys are set
    in the request_json, the related value ist updated. There is no json
    response. To get the updated data, retrieve again.
    """
    scenario = models.Scenario.query.filter_by(id=id).first()
    if not scenario:
        raise NotFound(f"scenario not found by id={id}")

    request_data = request.get_json()

    try:
        new_name = request_data["name"]
        scenario.name = new_name
    except KeyError:
        logging.info("No name change detected.")

    try:
        patients_add = request_data["patients_add"]
        patients_del = request_data["patients_del"]
        __update_patients_in_scenario(scenario, patients_add=patients_add,
                                      patients_del=patients_del)
    except KeyError:
        logging.info("No or inconsistent patient-add changes detected")

    try:
        vehicles_add = request_data["vehicles_add"]
        vehicles_del = request_data["vehicles_del"]
        __update_vehicle_in_scenario(scenario, vehicles_add=vehicles_add,
                                     vehicles_del=vehicles_del)
    except KeyError:
        logging.info("No or inconsistent vehicle changes detected")

    db.session.commit()
    return "Successfully updated patient", 200


def __update_patients_in_scenario(scenario, patients_add=None, patients_del=None):
    """
    Edits the vehicles registered on the provided scenario. Depending on the
    quantity and existence an entry is created, removed or edited.
    """
    if patients_add and patients_del:
        patientNamesAdd = [item["name"] for item in patients_add]
        patientNamesDel = [item["name"] for item in patients_del]

        common_elements = set(patientNamesAdd) & set(patientNamesDel)

        patients_add = [item for item in patients_add if item["name"] not in common_elements]
        patients_del = [item for item in patients_del if item["name"] not in common_elements]

    try:
        if patients_del:
            for patient_del in patients_del:
                db.session.query(models.PatientInScenario).filter(
                    models.PatientInScenario.scenario_id == scenario.id,
                    models.PatientInScenario.name == patient_del["name"]
                ).delete()

        if patients_add:
            for patient_add in patients_add:
                patient = models.PatientInScenario.query.filter_by(
                    scenario_id=scenario.id,
                    name=patient_add["name"]
                ).first()
                # prevent primary collision
                if not patient:
                    patient = models.PatientInScenario(
                        scenario_id=scenario.id,
                        patient_id=patient_add["id"],
                        name=patient_add["name"]
                    )
                    db.session.add(patient)

        db.session.commit()
        logging.info(f"Update patients for scenario {scenario.id}")
    except KeyError:
        raise BadRequest("Invalid or missing parameter for patients detected")


def __update_vehicle_in_scenario(scenario, vehicles_add: dict=None, vehicles_del=None):
    """
    Edits the vehicles registered on the provided scenario. Depending on the
    quantity and existence an entry is created, removed or edited.
    """
    if vehicles_add and vehicles_del:
        vehicleNamesAdd = [item["name"] for item in vehicles_add]
        vehicleNamesDel = [item["name"] for item in vehicles_del]

        common_elements = set(vehicleNamesAdd) & set(vehicleNamesDel)

        vehicles_add = [item for item in vehicles_add if item["name"] not in common_elements]
        vehicles_del = [item for item in vehicles_del if item["name"] not in common_elements]

    try:
        if vehicles_del:
            for vehicle_del in vehicles_del:
                db.session.query(models.PlayersToVehicleInExecution).filter(
                    models.PlayersToVehicleInExecution.scenario_id == scenario.id,
                    models.PlayersToVehicleInExecution.vehicle_name == vehicle_del["name"]
                ).delete()

        if vehicles_add:
            for vehicle_add in vehicles_add:
                vehicle = models.PlayersToVehicleInExecution.query.filter_by(
                    scenario_id=scenario.id,
                    vehicle_name=vehicle_add["name"]
                ).first()
                # prevent primary collision
                if not vehicle:
                    # FIXME add entry for all execution entries in db
                    vehicle = models.PlayersToVehicleInExecution(
                        scenario_id=scenario.id,
                        location_id=vehicle_add["id"],
                        vehicle_name=vehicle_add["name"]
                    )
                    db.session.add(vehicle)

        db.session.commit()
        logging.info(f"Update vehicles for scenario {scenario.id}")

    except KeyError:
        raise BadRequest("Invalid or missing parameter for vehicles detected")
