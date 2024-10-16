import logging

from flask import Blueprint, Response
from string_utils import booleanize
from werkzeug.exceptions import NotFound, BadRequest, InternalServerError, \
    Forbidden

import models
from app_config import csrf, db
from execution.entities.event import Event
from execution import run
from execution.entities.execution import Execution
from execution.entities.player import Player
from execution.services import entityloader
from execution.services.entityloader import load_location, load_role
from execution.utils.util import try_get_execution
from utils.dbo import add_vehicles_to_execution_to_session
from utils.decorator import required, RequiredValueSource, cache

from sqlalchemy import select

from utils.tans import unique

web_api = Blueprint("web_api-lobby", __name__)


@web_api.get("/execution")
@required("id", int, RequiredValueSource.ARGS)
def get_execution(id: int):
    # Add the execution to the active executions in case it stems from the database
    if id in run.active_executions.keys():
        execution = run.active_executions[id]
    else:
        execution: bool | Execution = entityloader.load_execution(id,
                                                                  save_in_memory=False)

    if isinstance(execution, bool) and not execution:
        raise NotFound(f"Execution with id={id} does not exist")
    elif isinstance(execution, bool) and execution:
        raise InternalServerError("Execution found but invalid return type "
                                  "provided.")
    else:
        return {
            "id": execution.id,
            "name": execution.name,
            "status": execution.status.name,
            "players": [{
                "tan": player.tan,
                "name": player.name,
                "alerted": player.alerted,
                "logged_in": player.logged_in,
                "role": player.role.to_dict(
                    include=["id", "name"]) if player.role else None,
                "location": player.location.to_dict(
                    include=["id", "name"]) if player.location else None
            } for player in execution.players.values()],
            "roles": [{
                "id": x.id,
                "name": x.name
            } for x in __get_roles()],
            "locations": [{
                "id": x[1],
                "name": x[0]
            } for x in __get_top_level_locations(execution.id)],
            "notifications": execution.notifications,
            "patients": [
                {
                    "id": patient.id,
                    "name": patient.name
                } for patient in execution.scenario.patients.values()]
        }


@web_api.post("/execution/create")
@required("scenario_id", int, RequiredValueSource.FORM)
@required("name", str, RequiredValueSource.FORM)
def create_execution(scenario_id: int, name: str):
    # TODO implement validator to prevent empty scenarios
    try:
        new_execution = models.Execution(scenario_id=scenario_id,  # type: ignore
                                         name=name)  # type: ignore
        db.session.add(new_execution)
        db.session.commit()

        # Case: first execution of scenario -> reassign wildcard entries
        vehicle_list = models.PlayersToVehicleInExecution.query.filter_by(
            execution_id=None,  # wildcard
            scenario_id=scenario_id
        ).all()

        if len(vehicle_list) > 0:
            tan_list = []
            for vehicle in vehicle_list:
                vehicle.execution_id = new_execution.id
                tan_list.append(vehicle.player_tan)

            player_list: list[models.Player] = models.Player.query.filter_by(
                execution_id=None).all()
            for player in player_list:
                # Only assign player which are connected to the scenario
                if player.tan in tan_list:
                    player.execution_id = new_execution.id
        else:
            template_vehicles = (models.PlayersToVehicleInExecution.query
                                .filter_by(scenario_id=scenario_id).where(
                                    models.PlayersToVehicleInExecution.execution_id != None)
                                .all())
            assert template_vehicles
            for template_vehicle in template_vehicles:
                add_vehicles_to_execution_to_session(new_execution.id, scenario_id,
                                                     template_vehicle.location_id,
                                                     template_vehicle.vehicle_name,
                                                     template_vehicle.travel_time)

        db.session.commit()
        logging.info(f"new execution created with id: {new_execution.id}")
        return {"id": new_execution.id}, 201
    except Exception:
        message = ("Unable to save execution. "
                   "Possibly invalid parameter provided")
        logging.error(message)
        return message, 400


@web_api.post("/execution/delete")
@required("execution_id", int, RequiredValueSource.FORM)
def delete_execution(execution_id: int):
    from execution.run import deactivate_execution
    # delete player assignment
    db_p_assignments = (models.PlayersToVehicleInExecution.query
                        .filter_by(execution_id=execution_id)).all()
    assert len(db_p_assignments) > 0

    # retrieves all executions stored for a scenario
    execution_in_scenario_query = select(
        models.PlayersToVehicleInExecution.execution_id,
        models.PlayersToVehicleInExecution.scenario_id
    ).where(models.PlayersToVehicleInExecution.scenario_id == db_p_assignments[0].scenario_id
    ).distinct(models.PlayersToVehicleInExecution.execution_id)

    execution_list = db.session.execute(execution_in_scenario_query).all()

    for db_p_assignment in db_p_assignments:
        if len(execution_list) == 1:
            # keep initial setup when deleting last execution
            db_p_assignment.execution_id = None
        else:
            db.session.delete(db_p_assignment)

    # delete Player
    db_players = models.Player.query.filter_by(execution_id=execution_id).all()
    if len(execution_list) > 1:
        # only delete player if more than one execution exists
        [db.session.delete(dbo) for dbo in db_players]

    # delete execution
    db_execution = models.Execution.query.filter_by(id=execution_id).first()
    db.session.delete(db_execution)

    db.session.commit()

    deactivate_execution(execution_id)

    return f"Successfully deleted execution with id={execution_id}", 200


@web_api.patch("/execution")
@required("id", int, RequiredValueSource.ARGS)
@required("new_status", str.upper, RequiredValueSource.FORM)
@csrf.exempt  # changes are applied via buttons. Therefore, no CSRF required
def change_execution_status(id: int, new_status: str):
    execution = try_get_execution(id)
    try:
        new_status_enum = Execution.Status[new_status]
        __perform_state_change(new_status_enum, execution)
        execution.status = new_status_enum
        return Response(status=200)

    except KeyError:
        raise BadRequest(f"Not an option for the execution status: "
                         f"'{new_status}'. ")


@web_api.post("/execution/activate")
@required("id", int, RequiredValueSource.FORM)
@csrf.exempt
def activate_execution(id: int):
    if id in run.active_executions.keys():
        return run.active_executions[id].to_dict(), 200
    if entityloader.load_execution(id):
        return run.active_executions[id].to_dict(), 201

    # Failure
    raise NotFound(f"Execution with id={id} does not exist")


@web_api.get("/execution/active")
def get_all_active_executions():
    """ Endpoint to return all currently active executions. """
    return [execution.to_dict(shallow=True) for execution
            in run.active_executions.values()]


@web_api.patch("/execution/player/status")
@required("id", int, RequiredValueSource.ARGS)
@required("tan", str, RequiredValueSource.ARGS)
@required("alerted", booleanize, RequiredValueSource.FORM)
def change_player_status(id: int, tan: str, alerted: bool):
    execution = try_get_execution(id)
    try:
        player = execution.players[tan]
    except KeyError:
        raise NotFound(
            f"Player with TAN '{tan}' does not exist for execution with id {id}")
    if not alerted:
        vehicle_player_map = execution.get_vehicle_player_map()
        if player.location:
            player_list = vehicle_player_map[player.location.id]
            player.location.available = True
            Event.vehicle_available(execution_id=execution.id,
                                    time=player.alerted_timestamp,
                                    vehicle_id=player.location.id)
            for player in player_list:
                player.alert()
                Event.player_alerted(execution_id=execution.id,
                                     time=player.alerted_timestamp,
                                     player=player.tan).log()
        else:
            player.alert()
            Event.player_alerted(execution_id=execution.id,
                                 time=player.alerted_timestamp,
                                 player=player.tan).log()
    else:
        player.remove_alert()

    return Response(status=200)


@web_api.post("/execution/create-player")
@required("id", int, RequiredValueSource.ARGS)
@required("role", int, RequiredValueSource.FORM)
@required("vehicle", str, RequiredValueSource.FORM)
def add_new_player(id: int, role: int, vehicle: str):
    execution = try_get_execution(id)
    __add_new_player_to_execution(execution, role, vehicle)
    return Response(status=200)


@web_api.post("/execution/delete-player")
@required("id", int, RequiredValueSource.ARGS)
@required("tan", str, RequiredValueSource.FORM)
@required("vehicle", str, RequiredValueSource.FORM)
def delete_player(id: int, tan: str, vehicle: str):
    execution = try_get_execution(id)
    __delete_player(execution, tan, vehicle)
    return Response(status=200)


@cache
def __get_roles() -> list[models.Role]:
    """
    Gets all roles currently stored in the database. For efficient access the
    result is cached for subsequent function calls as the DB is not expected to
    change during

    :return: List of roles
    """
    return models.Role.query.all()


@cache
def __get_top_level_locations(execution_id: int):
    top_level_location_query = (
        select(
            models.PlayersToVehicleInExecution.vehicle_name,
            models.PlayersToVehicleInExecution.location_id)
        .where(
            models.PlayersToVehicleInExecution.execution_id == execution_id)
        .group_by(
            models.PlayersToVehicleInExecution.vehicle_name,
            models.PlayersToVehicleInExecution.location_id))
    vehicle = db.session.execute(top_level_location_query).all()
    return vehicle


def __delete_player(execution: Execution, tan: str, vehicle: str):
    from execution.run import remove_player
    players_to_vehicle = models.PlayersToVehicleInExecution.query.filter_by(
        execution_id=execution.id,
        vehicle_name=vehicle
    ).all()

    if len(players_to_vehicle) > 1:  # at least one player per vehicle
        player = models.Player.query.filter_by(tan=tan).first()
        player_to_vehicle = models.PlayersToVehicleInExecution.query.filter_by(
            execution_id=execution.id,
            player_tan=tan
        ).first()

        if not player:
            raise BadRequest(f"Player with tan={tan} not found for "
                             f"execution={execution.id}")
        if player_to_vehicle:
            db.session.delete(player_to_vehicle)

        db.session.delete(player)
        db.session.commit()

        if execution.status is execution.Status.PENDING or execution.Status.RUNNING:
            execution.players.pop(tan)
            remove_player(tan)
    else:
        raise Forbidden("Unable to delete player. One player per vehicle is required")


def __add_new_player_to_execution(execution: Execution, role: int,
                                  vehicle: str):
    from execution.run import register_player  # circular import prevention

    players_to_vehicle = models.PlayersToVehicleInExecution.query.filter_by(
        execution_id=execution.id,
        vehicle_name=vehicle,
    ).all()
    if len(players_to_vehicle) > 0:

        player_to_vehicle = players_to_vehicle[0]

        tan = str(unique())
        player = (models.Player(tan=tan, execution_id=execution.id, # type: ignore
                                location_id=player_to_vehicle.location_id, # type: ignore
                                role_id=role,  # type: ignore
                                alerted=False))  # type: ignore

        new_seat_in_vehicle = models.PlayersToVehicleInExecution(
            execution_id=execution.id,  # type: ignore
            scenario_id=player_to_vehicle.scenario_id,  # type: ignore
            player_tan=tan,  # type: ignore
            location_id=player_to_vehicle.location_id,  # type: ignore
            vehicle_name=player_to_vehicle.vehicle_name,  # type: ignore
            travel_time=player_to_vehicle.travel_time)  # type: ignore

        db.session.add(player)
        db.session.add(new_seat_in_vehicle)
        db.session.commit()

        # load player location -> choose from existing or load new vehicle
        location = execution.get_location_for_player(
            player_to_vehicle.vehicle_name)
        if not location:
            location = load_location(player_to_vehicle.location_id)
        new_player = Player(tan, None, False, 0, location, set(), load_role(role))

        # Add player to execution
        execution.players[tan] = new_player
        # Register player if execution is activated
        if execution.status is execution.Status.PENDING or execution.Status.RUNNING:
            register_player(execution.id, [new_player])
    else:
        msg = (f"Unable to assign player to vehicle. No vehicle found for:"
               f"{execution.id}{vehicle}")
        logging.error(msg)
        raise BadRequest(msg)


def __perform_state_change(new_status: Execution.Status, execution: Execution):
    # current status
    match execution.status:
        case Execution.Status.PENDING:
            if new_status is Execution.Status.RUNNING:
                execution.start_execution()
            elif new_status is Execution.Status.UNKNOWN:
                run.deactivate_execution(execution.id)
            elif new_status is Execution.Status.PENDING:
                return
            else:
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.RUNNING:
            if new_status is Execution.Status.PENDING:
                execution.pause_execution()
            elif new_status is Execution.Status.FINISHED:
                execution.archive()
                run.deactivate_execution(execution.id)
            elif new_status is Execution.Status.RUNNING:
                return
            else:
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.FINISHED:
            if new_status is Execution.Status.FINISHED:
                return
            else:
                # no repetition allowed at this point.
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
        case Execution.Status.UNKNOWN:
            if new_status is Execution.Status.PENDING:
                run.activate_execution(execution)
                return
            else:
                # indicates no registration of execution. Status is set by
                # activating the execution
                raise BadRequest("Process manipulation detected. "
                                 "Invalid State change")
