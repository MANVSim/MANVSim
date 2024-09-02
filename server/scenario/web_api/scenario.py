import logging

from flask import Blueprint, request
from sqlalchemy import select, distinct, asc
from werkzeug.exceptions import NotFound, BadRequest

import models
from models import WebUser
from app_config import db, csrf
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
@role_required(WebUser.Role.READ_ONLY)
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

    vehicle_query = select(distinct(models.PlayersToVehicleInExecution.vehicle_name),
                           models.PlayersToVehicleInExecution.location_id).where(
        models.PlayersToVehicleInExecution.scenario_id == scenario_id
    ).order_by(asc(models.PlayersToVehicleInExecution.vehicle_name))
    vehicle_list = db.session.execute(vehicle_query)

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
                "id": vehicle[1],
                "name": vehicle[0],
            } for vehicle in vehicle_list
        ]
    }


@web_api.post("/scenario")
@csrf.exempt
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
        if new_name:
            scenario.name = new_name
    except KeyError:
        logging.info("No name change detected.")

    try:
        patients_add = request_data["patients_add"]
        patients_del = request_data["patients_del"]
        __update_patients_in_scenario(scenario, patients_add=patients_add,
                                      patients_del=patients_del)
    except KeyError:
        logging.info("No or inconsistent patient changes detected")

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
        # if names are marked for deletion as well as addition, do nothing
        patientNamesAdd = [item["name"] for item in patients_add]
        patientNamesDel = [item["name"] for item in patients_del]

        common_elements = set(patientNamesAdd) & set(patientNamesDel)

        patients_add = [item for item in patients_add if item["name"] not in common_elements]
        patients_del = [item for item in patients_del if item["name"] not in common_elements]

    try:
        if patients_del:
            # remove all patients from scenario by provided name
            for patient_del in patients_del:
                db.session.query(models.PatientInScenario).filter(
                    models.PatientInScenario.scenario_id == scenario.id,
                    models.PatientInScenario.name == patient_del["name"]
                ).delete()

        if patients_add:
            for patient_add in patients_add:
                patient = models.PatientInScenario(
                    scenario_id=scenario.id,
                    patient_id=patient_add["id"],
                    name=patient_add["name"]
                )
                db.session.add(patient)

        db.session.commit()
        logging.info(f"Updated patients for scenario {scenario.id}")
    except KeyError:
        raise BadRequest("Invalid or missing parameter for patients detected")


def __update_vehicle_in_scenario(scenario, vehicles_add=None, vehicles_del=None):
    """
    Edits the vehicles registered on the provided scenario. Depending on the
    quantity and existence an entry is created, removed or edited.
    """
    if vehicles_add and vehicles_del:
        # if names are marked for deletion as well as addition, do nothing
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
            __add_vehicles_to_execution(scenario, vehicles_add)

        db.session.commit()
        logging.info(f"Updated vehicles for scenario {scenario.id}")

    except KeyError:
        raise BadRequest("Invalid or missing parameter for vehicles detected")


def __add_vehicles_to_execution(scenario, vehicles_add):
    """
    This method adds a new vehicle to all executions that are referenced with
    the provided scenario id. In case no execution is created for a scenario,
    the method used execution_id=0 as wildcard for the initial creation of
    a corresponding execution.
    """
    # Get all execution ids for scenario from PlayersToVehicle table
    execution_ids_query = select(
        distinct(models.PlayersToVehicleInExecution.execution_id)
    ).where(models.PlayersToVehicleInExecution.scenario_id == scenario.id)

    execution_ids = [row[0] for row in
                     db.session.execute(execution_ids_query)]

    if not execution_ids:
        # Unused scenario in DB -> create entries with id execution_id = 0
        # (execution_id=0) indicates an uncreated game for scenarios.
        # Causes changes on how an execution is created
        execution_ids = [0]

    for vehicle_add in vehicles_add:
        # Add new vehicle to every execution stored for the scenario
        for exec_id in execution_ids:
            vehicle = models.PlayersToVehicleInExecution(
                execution_id=exec_id,
                scenario_id=scenario.id,
                location_id=vehicle_add["id"],
                vehicle_name=vehicle_add["name"],
                player_tan=f"empty-{vehicle_add["name"]}"
            )
            db.session.add(vehicle)
