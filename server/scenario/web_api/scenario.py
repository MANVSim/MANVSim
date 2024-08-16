import logging

from flask import Blueprint, request
from werkzeug.exceptions import NotFound, BadRequest

import models
from app_config import db
from utils.decorator import admin_only, required, RequiredValueSource

web_api = Blueprint("web_api-scenario", __name__)


# -- DBO Execution

@web_api.get("/templates")
@admin_only
def get_execution():
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

    patient_list = (models.Patient.query.join(
        models.TakesPartIn,
        models.Patient.id == models.TakesPartIn.patient_id
    ).filter(
        models.TakesPartIn.scenario_id == scenario_id
    ).all())

    vehicle_list = models.Location.query.filter_by(is_vehicle=True)
    vehicle_quantity_list = (models.LocationQuantityInScenario.query.join(
        models.Location,
        models.LocationQuantityInScenario.location_id == models.Location.id
    ).filter(
        models.LocationQuantityInScenario.scenario_id == scenario_id
    ).all())

    return {
        "id": scenario.id,
        "name": scenario.name,
        "patients": [
            {
                "id": patient.id,
                "name": patient.name
            }
            for patient in patient_list
        ],
        "vehicles": [
            {
                "id": vehicle.id,
                "name": vehicle.name
            } for vehicle in vehicle_list
        ],
        "vehicles-quantity": [
            {
                "id": vehicle.id,
                "name": vehicle.location.name,
                "quantity": vehicle.quantity
            } for vehicle in vehicle_quantity_list
        ]
    }


@web_api.post("/scenario")
def create_scenario():
    """ Creates an empty scenario dbo. """
    scenario = models.Scenario(name="Neues Scenario")
    db.session.add(scenario)
    db.session.commit()

    vehicle_list = models.Location.query.filter_by(is_vehicle=True)
    return {
        "id": scenario.id,
        "name": scenario.name,
        "patients": [],
        "vehicles": [
            {
                "id": vehicle.id,
                "name": vehicle.name
            } for vehicle in vehicle_list
        ],
        "vehicles-quantity": []
    }


@web_api.patch("/scenario")
@required("id", int, RequiredValueSource.JSON)
def edit_scenario(id: int):
    """
    Endpoint to update an existing scenario. If the related keys are set
    in the request_json, the related value ist updated. There is no json
    response. To get the updated data, retrieve again.
    """
    request_data = request.get_json()
    scenario = models.Scenario.query.filter_by(id=id).first()
    if not scenario:
        raise NotFound(f"scenario not found by id={id}")
    try:
        new_name = request_data["name"]
        scenario.name = new_name
    except KeyError:
        logging.info("No name change detected.")

    try:
        new_patients = request_data["patients"]
        __update_patients_in_scenario(scenario, new_patients)
    except KeyError:
        logging.info("No patient changes detected")

    try:
        new_vehicle = request_data["vehicle"]
        __update_vehicle_in_scenario(scenario, new_vehicle)
    except KeyError:
        logging.info("No vehicle changes detected")

    db.session.commit()
    return "Successfully updated patient", 200


def __update_patients_in_scenario(scenario, new_patients):
    """
    Edits the vehicles registered on the provided scenario. Depending on the
    quantity and existence an entry is created, removed or edited.
    """
    try:
        for patient_data in new_patients:
            patient = models.TakesPartIn.query.filter_by(
                scenario_id=scenario.id, patient_id=patient_data["id"]).first()
            quantity = int(patient_data["quantity"])
            if quantity <= 0 and not patient:
                continue
            elif not patient:
                patient = models.TakesPartIn(
                    quantity=int(patient_data["quantity"]),
                    scenario_id=scenario.id,
                    patient_id=patient_data["id"]
                )
                db.session.add(patient)
            elif quantity <= 0:
                db.session.delete(patient)
            else:
                patient.quantity = int(patient_data["quantity"])
    except KeyError:
        raise BadRequest("Invalid or missing parameter for patients detected")


def __update_vehicle_in_scenario(scenario, new_vehicles):
    """
    Edits the vehicles registered on the provided scenario. Depending on the
    quantity and existence an entry is created, removed or edited.
    """
    try:
        for vehicle_data in new_vehicles:
            vehicle = models.LocationQuantityInScenario.query.filter_by(
                scenario_id=scenario.id,
                location_id=int(vehicle_data["id"])).first()
            quantity = int(vehicle_data["quantity"])
            if not vehicle and quantity <= 0:
                continue
            elif not vehicle:
                vehicle = models.TakesPartIn(
                    quantity=int(vehicle_data["quantity"]),
                    scenario_id=scenario.id,
                    patient_id=int(vehicle_data["id"])
                )
                db.session.add(vehicle)
            elif quantity <= 0:
                db.session.delete(vehicle)
            else:
                vehicle.quantity = int(vehicle_data["quantity"])

    except KeyError:
        raise BadRequest("Invalid or missing parameter for patients detected")
