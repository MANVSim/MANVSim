"""
This file is the main execution module file. It contains all valid methods to create a scenario-game along with
scenario-state-changing methods. It uses DBO instances of the web-module and logs any action of interest into a
separate file (FIXME: docu update @Louis)
"""

import logging

from execution.entities.execution import Execution
from execution.entities.player import Player
from execution.entities.scenario import Scenario
from execution.tests.entities import dummy_entities

# FIXME: Remove hardcoded test data
# TEST DATA
player_a = Player("69", "Finn Bartels", False, 10,  None, set())

test_a = Execution(1337, "ExcName", Scenario(17, "Test-Scenario-Pending", {}, {}, {}), {"69": player_a}, Execution.Status.PENDING)
test_b = dummy_entities.create_test_execution()
test_b.status = Execution.Status.RUNNING

# Dictionary storing the currently available executions, whether they are PENDING, RUNNING or about to FINISH
active_executions: dict[int, Execution] = {
    # "exec_id": "exec: execution_dbo"
    1337: test_a,
    test_b.id: test_b,
}

# Dictionary storing all active players in an execution
registered_players: dict[str, int] = {
    # "TAN" : "exec_uuid"
    "69": 1337,
    "123ABC": test_b.id,
    "456DEF": test_b.id,
}


# CREATE
def activate_execution(execution: Execution):
    active_executions[execution.id] = execution
    register_player(execution.id, execution.players.values())


def register_player(exec_id, players):
    for player in players:
        registered_players[player.tan] = exec_id  # player_tan is unique due to database primary key


# DELETE
def deactivate_execution(exec_id: int):
    try:
        execution = active_executions.pop(exec_id)
        remove_player(execution.players.values())
    except KeyError:
        logging.error(f"{exec_id} already removed")


def remove_player(players):
    for player in players:
        try:
            registered_players.pop(player.tan)
        except KeyError:
            logging.info(f"{player.tan} already removed")
