from executions import run
from executions.entities.action import Action
from executions.entities.execution import Execution
from executions.entities.location import Location
from executions.entities.patient import Patient
from executions.entities.player import Player
from executions.entities.scenario import Scenario
from utils.database import Database

DB_PATH = "../../instance/db.sqlite3"


def __load_patients(scenario_id: int, db: Database) -> list[Patient] | None:
    # TODO
    pass


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


def __load_locations(db: Database) -> dict[int, Location] | None:
    # TODO
    pass


def __load_scenario(scenario_id: int, db: Database) -> Scenario | None:
    """ Loads the scenario with the given id from the database and returns it or None (in case of an error). """
    # Load scenario data
    res = db.try_execute(f"SELECT * FROM scenario WHERE id = {scenario_id}")
    if not res:
        return None
    scenario_id, scenario_name = res[0]

    # Load all patients in this scenario
    patients = __load_patients(scenario_id, db)
    if not patients:
        return None

    # Load all actions
    actions = __load_actions(db)
    if not actions:
        return None

    # Load all locations
    locations = __load_locations(db)
    if not locations:
        return None

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
    Loads an Execution (Simulation) and all associated data into memory prepare it for execution.

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
        run.create_execution(execution)
        return True
