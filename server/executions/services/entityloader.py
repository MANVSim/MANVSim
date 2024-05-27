import uuid

from executions import run
from executions.entities.action import Action
from executions.entities.execution import Execution
from executions.entities.location import Location
from executions.entities.patient import Patient
from executions.entities.performed_action import PerformedAction
from executions.entities.player import Player
from executions.entities.resource import Resource
from executions.entities.scenario import Scenario
from utils.database import Database

DB_PATH = "../../instance/db.sqlite3"


def __load_patients(scenario_id: int, actions: list[Action], db: Database) -> list[Patient]:
    """ Loads all patients associated with the given scenario from the database and returns them in a list. """
    patient_ids = [r[1] for r in
                   db.try_execute(f"SELECT patient_id FROM takes_part_in WHERE scenario_id = {scenario_id}")]
    patient_data = db.try_execute(f"SELECT * FROM patients WHERE patient_id IN {patient_ids}")
    patients = []
    for patient in patient_data:
        p_id, injuries, activity_diagram = patient
        p_loc = Location(id=str(uuid.uuid4()), name=f"Patient with ID {p_id}", picture_ref=None, resources=[])
        perf_acts_data = db.try_execute(f"SELECT * FROM performed_actions WHERE patient_id = {p_id}")
        performed_actions = []
        if perf_acts_data:
            for perf_act in perf_acts_data:
                pa_id, start_time, exec_id, p_id, action_id = perf_act
                action = filter(lambda act: act.id == action_id, actions)[0] if filter(lambda act: act.id == action_id,
                                                                                       actions) else None
                performed_actions.append(PerformedAction(id=pa_id, time=start_time, execution_id=exec_id, action=action,
                                                         resources_used=[], player_tan=""))
        patients.append(Patient(id=p_id, name="", injuries=injuries, activity_diagram=activity_diagram, location=p_loc,
                                performed_actions=performed_actions))

    return patients


def __load_actions(db: Database) -> list[Action] | None:
    """ Loads all actions from the database and returns them in a list or None (in case of an error). """

    def __get_needed_resource_names(action_id: int) -> list[str]:
        """ Returns a list of the names of all resources needed for the given action. """
        resource_ids = [r[0] for r in
                        db.try_execute(f"SELECT ressource_id FROM ressources_needed WHERE action_id = {action_id}")]
        resource_names = db.try_execute(f"SELECT name FROM ressource WHERE id IN {resource_ids}")

        return [r[0] for r in resource_names]

    res = db.try_execute("SELECT * FROM action")
    if not res:
        return None

    actions = []
    for action_data in res:
        resources_needed = __get_needed_resource_names(action_data[0])
        actions.append(Action(id=action_data[0], name=action_data[1], result=action_data[3], picture_ref=action_data[2],
                              duration_sec=action_data[4], resources_needed=resources_needed))

    return actions


def __load_scenario(scenario_id: int, db: Database) -> Scenario | None:
    """ Loads the scenario with the given id from the database and returns it or None (in case of an error). """
    # Load scenario data
    res = db.try_execute(f"SELECT * FROM scenario WHERE id = {scenario_id}")
    if not res:
        return None
    scenario_id, scenario_name = res[0]

    # Load all actions
    actions = __load_actions(db)
    if not actions:
        return None

    # Load all patients in this scenario
    patients = __load_patients(scenario_id, actions, db)
    if not patients:
        return None

    # Locations are loaded on-demand as there is no mapping between scenario/execution and locations. Only exception are
    # those locations created for patients during object initialization.
    locations = {}
    for patient in patients:
        patient_location = patient.location
        locations[patient_location.id] = patient_location

    return Scenario(id=scenario_id, name=scenario_name, patients=patients, actions=actions, locations=locations)


def __load_players(exec_tan: str, db: Database) -> list[Player] | None:
    """ Loads all players of the given Execution from the database and returns them in a list or None."""
    res = db.try_execute(f"SELECT * FROM player WHERE execution_tan = {exec_tan}")
    if not res:
        return None

    players = []
    for player_data in res:
        players.append(Player(tan=player_data[0], name=None, location=None, accessible_locations=[]))

    return players


def load_execution(tan: str) -> bool:
    """
    Loads an Execution (Simulation) and all associated data into memory and activates it to make it ready for execution.

    Returns True for success, False otherwise.
    """
    with Database(DB_PATH) as db:
        res = db.try_execute(f"SELECT * FROM execution WHERE tan = {tan}")
        # If query yields no result, report failure
        if not res:
            return False

        exec_tan, scenario_id, exec_starting_time = res[0]

        players = __load_players(exec_tan, db)
        # If players could not be loaded, report failure
        if not players:
            return False

        scenario = __load_scenario(scenario_id, db)
        # If scenario data could not be loaded, report failure
        if not scenario:
            return False

        execution = Execution(id=exec_tan, scenario=scenario, starting_time=-1, players=players,
                              status=Execution.Status.PENDING)
        # Activate execution (makes it accessible by API)
        run.activate_execution(execution)
        return True


def __load_resources(location_id: int, db: Database) -> list[Resource]:
    """ Creates a list of resources located at the given location. """
    res = db.try_execute(f"SELECT * FROM resource WHERE location_id = {location_id}")

    resources = []
    for r_id, name, location_id in res:
        existing_resource = list(filter(lambda r: r.id == r_id, resources))
        if not existing_resource:
            resources.append(Resource(id=r_id, name=name, quantity=1, picture_ref=None))
        else:
            existing_resource[0].quantity += 1

    return resources


def load_location(location_id: int) -> Location | None:
    """
    Loads the location with the given id from the database along with all referenced resources and nested locations.

    Returns Location object or None (in case of an error).
    """
    with Database(DB_PATH) as db:
        res = db.try_execute(f"SELECT * FROM location WHERE id = {location_id}")
        if not res:
            return None

        loc_id, name, nested_loc_id = res[0]

        resources = __load_resources(nested_loc_id, db)

        nested_loc = None
        if nested_loc_id:
            nested_loc = load_location(nested_loc_id)
            if not nested_loc:
                return None

        return Location(id=loc_id, name=name, picture_ref=None, resources=resources, location=nested_loc)
