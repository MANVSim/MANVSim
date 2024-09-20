from json import JSONDecodeError

from flask import current_app

import models
import utils.time
from app_config import db
from execution import run
from execution.entities.action import Action
from execution.entities.execution import Execution
from execution.entities.location import Location
from execution.entities.patient import Patient
from execution.entities.player import Player
from execution.entities.resource import Resource
from execution.entities.role import Role
from execution.entities.scenario import Scenario
from execution.entities.stategraphs.activity_diagram import ActivityDiagram
from media.media_data import MediaData
from vars import RESULT_DELIMITER

blocked_hash = 0


def __generate_id() -> int:
    global blocked_hash

    new_hash = hash(utils.time.current_time_ms())
    while new_hash == blocked_hash:
        new_hash = hash(utils.time.current_time_ms())

    blocked_hash = new_hash
    return new_hash


def __load_resources(location_id: int) -> list[Resource]:
    """ Creates a list of resources located at the given location. """
    res_in_loc = db.session.query(models.ResourceInLocation).filter(
        models.ResourceInLocation.location_id == location_id).all()

    resources = []
    for res in res_in_loc:
        r = db.session.query(models.Resource).filter(
            models.Resource.id == res.id).first()
        if r:
            media_refs = MediaData.list_from_json(
                r.media_refs) if r.media_refs else []

            new_hash = __generate_id()
            resources.append(
                Resource(id=new_hash, name=r.name, quantity=res.quantity,
                         media_references=media_refs))

    return resources


def load_location(location_id: int) -> (Location | None):
    """
    Loads the location with the given ID from the database along with all
    referenced resources and nested locations.

    :param location_id: The ID of the location to load
    :return: Location object or None (in case of an error)
    """
    with current_app.app_context():

        loc = db.session.query(models.Location).filter(
            models.Location.id == location_id).first()
        if not loc:
            return None

        resources = __load_resources(loc.id)

        children_locs = (db.session.query(models.LocationContainsLocation).
                         filter(
            models.LocationContainsLocation.parent == loc.id).all())
        sub_locs = set()
        for child in children_locs:
            sub_locs.add(load_location(location_id=child.child))

        media_refs = MediaData.list_from_json(
            loc.media_refs) if loc.media_refs else []

        new_hash = __generate_id()
        return Location(id=new_hash, name=loc.name,
                        media_references=media_refs,
                        is_vehicle=loc.is_vehicle, resources=resources,
                        sub_locations=sub_locs)


def __load_patients(scenario_id: int) -> dict[int, Patient]:
    """
    Loads all patients associated with the given scenario from the database
    and returns them in a dictionary.
    """
    patient_mapping = db.session.query(models.PatientInScenario).filter(
        models.PatientInScenario.scenario_id == scenario_id).all()

    patients: dict[int, Patient] = dict()
    patient_locations: dict[int, Location] = dict()  # cache for locations
    for mapping in patient_mapping:
        p = db.session.query(models.Patient).filter(
            models.Patient.id == mapping.patient_id).first()
        if not p:
            continue

        # Load Locations
        if p.location is None:
            new_hash = __generate_id()
            p_loc = Location(id=new_hash,
                             name=f"Aufenthaltsort von Patient {mapping.name}",
                             media_references=[], resources=[])
        elif p.location in patient_locations.keys():
            p_loc = patient_locations[p.location]
        else:
            p_loc = load_location(p.location)
            if p_loc:
                patient_locations[p.location] = p_loc
            else:
                new_hash = __generate_id()
                p_loc = Location(id=new_hash,
                                 name=f"Aufenthaltsort von Patient {mapping.name}",
                                 media_references=[], resources=[])

        # Load Media
        p_media = p.media_refs
        try:
            p_media = MediaData.list_from_json(p_media)
        except JSONDecodeError:
            p_media = []
        except TypeError:
            p_media = []

        # Load Activity Diagram
        p_ad = p.activity_diagram
        try:
            p_ad = ActivityDiagram().from_json(json_string=p_ad)
        except JSONDecodeError:  # thrown if p_ad is None or an invalid json string
            p_ad = ActivityDiagram()  # empty diagram with an empty root state
        except TypeError:
            p_ad = ActivityDiagram()  # empty diagram with an empty root state

        # Create Patient
        new_patient_id = __generate_id()
        patients[new_patient_id] = Patient(id=new_patient_id, name=mapping.name,
                                           activity_diagram=p_ad,
                                           # type: ignore
                                           location=p_loc, performed_actions=[],
                                           media_references=p_media)  # type: ignore

    return patients


def __load_actions() -> dict[int, Action] | None:
    """
    Loads all actions from the database and returns them in a dictionary or
    None (in case of an error).
    """

    def __get_needed_resource_names(action_id: int) -> list[str]:
        """
        Returns a list of the names of all resources needed for the given
        action.
        """
        resource_ids = [r.resource_id for r in
                        db.session.query(models.ResourcesNeeded).filter_by(
                            action_id=action_id).all()]
        resources = (db.session.query(models.Resource)
                     .filter(models.Resource.id.in_(resource_ids)).all())
        return [r.name for r in resources]

    acs = db.session.query(models.Action).all()
    if not acs:
        return None

    actions = dict()
    for ac in acs:
        resources_needed = __get_needed_resource_names(ac.id)
        media_refs = MediaData.list_from_json(
            ac.media_refs) if ac.media_refs else []
        actions[ac.id] = Action(id=ac.id, name=ac.name,
                                results=ac.results.split(RESULT_DELIMITER),
                                media_references=media_refs,
                                duration_sec=ac.duration_secs,
                                resources_needed=resources_needed,
                                required_power=ac.required_power)

    return actions


def __load_scenario(scenario_id: int) -> Scenario | None:
    """
    Loads the scenario with the given id from the database and returns it or
    None (in case of an error).
    """
    # Load scenario data
    scenario = (db.session.query(models.Scenario)
                .filter_by(id=scenario_id).first())
    if not scenario:
        return None

    # Load all actions
    actions = __load_actions()
    if actions is None:
        return None

    # Load all patients in this scenario
    patients = __load_patients(scenario_id)
    if patients is None:
        return None

    locations = {}
    for patient in patients.values():
        patient_location = patient.location
        locations[patient_location.id] = patient_location

    return Scenario(s_id=scenario.id, name=scenario.name, patients=patients,
                    actions=actions, locations=locations)


def load_role(role_id: int) -> Role | None:
    """ Loads and returns the a Role object for a given role ID. """
    role = (db.session.query(models.Role)
            .filter(models.Role.id == role_id).first())
    if not role:
        return None

    return Role(role.id, role.name, role.short_name, role.power)


def __load_players(exec_id: int) -> dict[str, Player] | None:
    """
    Loads all players of the given Execution from the database and return them
    in a dictionary or None.
    """
    ps: list[models.Player] = (db.session.query(models.Player)
                               .filter_by(execution_id=exec_id).all())
    if ps is None:
        return ps

    # Create associated vehicles (locations)
    vehicles: dict[str, Location] = dict()
    vehicle_mappings = db.session.query(
        models.PlayersToVehicleInExecution).filter_by(
        execution_id=exec_id).all()
    for mapping in vehicle_mappings:
        if mapping.vehicle_name not in vehicles.keys():
            vehicle_location = load_location(mapping.location_id)
            if vehicle_location:
                vehicle_location.name = mapping.vehicle_name
                vehicles[mapping.vehicle_name] = vehicle_location

    # Assign vehicles or load locations
    players: dict[str, Player] = dict()
    locations: dict[int, Location] = dict()
    for p in ps:
        player_role = load_role(p.role_id)
        db_player_loc = db.session.query(models.Location).filter_by(
            id=p.location_id).first()
        if not db_player_loc:
            continue
        # If the players location is a vehicle, select the associated one ...
        player_loc = None
        player_travel_time = 0
        if db_player_loc.is_vehicle:
            name_mapping = db.session.query(
                models.PlayersToVehicleInExecution).filter_by(
                player_tan=p.tan).first()
            if name_mapping:
                player_loc = vehicles[name_mapping.vehicle_name]
                player_travel_time = name_mapping.travel_time
        # ... otherwise load the given location (if it has not been loaded) ...
        elif p.location_id not in locations.keys():
            player_loc = load_location(p.location_id)
            if player_loc:
                locations[p.location_id] = player_loc
        # ... or assign the already loaded location object.
        else:
            player_loc = locations[p.location_id]

        players[p.tan] = Player(tan=p.tan, name=None, location=player_loc,
                                accessible_locations=set(), alerted=p.alerted,
                                activation_delay_sec=player_travel_time,
                                role=player_role)

    return players


def load_execution(exec_id: int, save_in_memory=True) -> bool | Execution:
    """
    Default: Loads an Execution (Simulation) and all associated data into memory
    and activates it to make it ready for execution.
    Returns True for success, False otherwise.

    If required the final memory loading is by-passed by editing the
    save_in_memory flag. The execution status stays UNKNOWN and the object
    itself is returned.
    """
    with current_app.app_context():
        ex = (db.session.query(models.Execution)
              .filter_by(id=exec_id).first())
        # If query yields no result, report failure
        if not ex:
            return False

        scenario = __load_scenario(ex.scenario_id)
        # If scenario data could not be loaded, report failure
        if scenario is None:
            return False

        players = __load_players(ex.id)
        # If players could not be loaded, report failure
        if players is None:
            return False

        # Add player starting locations to scenario locations
        for player in players.values():
            if player.location and player.location.id not in scenario.locations:
                scenario.locations[player.location.id] = player.location

        execution = Execution(id=ex.id, name=ex.name, scenario=scenario,
                              players=players,
                              status=
                              Execution.Status.PENDING if save_in_memory else
                              Execution.Status.UNKNOWN)
        # Activate execution (makes it accessible by API)
        if save_in_memory:
            run.activate_execution(execution)
            return True
        else:
            return execution
