import logging

from flask import Blueprint, request
from sqlalchemy import select, distinct, asc, desc
from werkzeug.exceptions import NotFound, BadRequest

import models
from models import WebUser
from app_config import db, csrf
from utils.dbo import add_vehicles_to_execution_to_session
from utils.decorator import role_required, required, RequiredValueSource
from utils.tans import unique

web_api = Blueprint("web_api-scenario", __name__)

# pyright: reportCallIssue=false
# pyright: reportAttributeAccessIssue=false
# The following statements are excluded from pyright, due to ORM specifics.


# -- DBO Execution

@web_api.get("/templates")
# @role_required(WebUser.Role.READ_ONLY)
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


@web_api.post("/scenario/delete")
@required("scenario_id", int, RequiredValueSource.ARGS)
def delete_scenario(scenario_id: int):
    try:
        # delete vehicle mappings for a scenario
        vehicle_mappings = models.PlayersToVehicleInExecution.query.filter_by(scenario_id=scenario_id).all()
        [db.session.delete(vehicle_mapping) for vehicle_mapping in vehicle_mappings]

        executions = db.session.query(models.Execution).filter_by(scenario_id=scenario_id).all()
        for execution in executions:
            # delete player in execution
            [db.session.delete(player) for player in models.Player.query.filter_by(execution_id=execution.id)]
            # delete execution
            db.session.delete(execution)

        # delete patient in scenario
        db.session.query(models.PatientInScenario).filter_by(scenario_id=scenario_id).delete()

        # delete scenario
        db.session.query(models.Scenario).filter_by(id=scenario_id).delete()

        db.session.commit()

        return "Successfully deleted scenario.", 200
    except Exception:
        return f"Error while deleting scenario {scenario_id}", 400


# -- DBO Scenario

@web_api.get("/scenario")
# @role_required(WebUser.Role.READ_ONLY)
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

    vehicle_query = (
        select(models.PlayersToVehicleInExecution.vehicle_name,
               models.PlayersToVehicleInExecution.location_id,
               models.PlayersToVehicleInExecution.travel_time)
        .where(models.PlayersToVehicleInExecution.scenario_id == scenario_id)
        .group_by(models.PlayersToVehicleInExecution.vehicle_name,
                  models.PlayersToVehicleInExecution.location_id,
                  models.PlayersToVehicleInExecution.travel_time)
        .order_by(asc(models.PlayersToVehicleInExecution.vehicle_name)))
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
                "travel_time": vehicle[2],
            } for vehicle in vehicle_list
        ]
    }


@web_api.post("/scenario")
@csrf.exempt
def create_scenario():
    """ Creates an empty scenario dbo. """
    scenario = models.Scenario(name="Neues Szenario")
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
    try:
        if vehicles_del:
            for vehicle_del in vehicles_del:
                vehicle_list = (models.PlayersToVehicleInExecution.query.
                                filter_by(scenario_id=scenario.id,
                                          vehicle_name=vehicle_del["name"])
                                ).all()
                player_list = [vehicle.player for vehicle in vehicle_list]

                [db.session.delete(vehicle) for vehicle in vehicle_list]
                [db.session.delete(player) for player in player_list]

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
    db_executions = (models.Execution.query.filter_by(scenario_id=scenario.id)
                     .all())

    execution_ids = [db_execution.id for db_execution in db_executions]

    if not execution_ids:
        # Unused scenario in DB -> create entries with id execution_id = 0
        # (execution_id=0) indicates an uncreated game for scenarios.
        # Causes changes on how an execution is created
        execution_ids = [0]

    for vehicle_add in vehicles_add:
        # Add new vehicle to every execution stored for the scenario
        for exec_id in execution_ids:
            add_vehicles_to_execution_to_session(
                exec_id if exec_id != 0 else None,
                scenario.id, vehicle_add["id"],
                vehicle_add["name"], vehicle_add["travel_time"]
            )
