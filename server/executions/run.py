"""
This file is the main execution module file. It contains all valid methods to create a scenario-game along with
scenario-state-changing methods. It uses DBO instances of the web-module and logs any action of interest into a
separate file (FIXME: docu update @Louis)
"""

import logging

from executions.entities.execution import Execution
from executions.entities.player import Player
from executions.entities.scenario import Scenario
from executions.tests import dummy_entities

# TEST DATA
player_a = Player("69", "Finn Bartels", Player.Role.UNKNOWN, False, 10, None, set())

test_a = Execution(1337, Scenario(17, "Test-Scenario-Pending", {}, {}, {}), {"69": player_a}, Execution.Status.PENDING)
test_b = dummy_entities.create_test_execution()
test_b.status = Execution.Status.RUNNING
test_b.id = 2
test_b.players[0].tan = "987ZYX"
test_b.players[1].tan = "654WVU"

# Dictionary storing the current available execution, whether they are PENDING, RUNNING or about to FINISH
exec_dict = {
    # "exec_id": "exec: execution_dbo"
    "1337": test_a,
    str(test_b.id): test_b,
}

# Dictionary storing all active players in an execution
registered_player = {
    # "TAN" : "exec_uuid"
    "69": "1337",
    test_b.players[0].tan: str(test_b.id),
    test_b.players[1].tan: str(test_b.id),
}


# CREATE
def create_execution(execution: Execution):
    exec_id = str(execution.id)  # exec id is unique due to database primary key
    exec_dict[exec_id] = execution
    register_player(exec_id, execution.players)


def register_player(exec_id, players):
    for player in players:
        registered_player[player.tan] = str(exec_id)  # player_tan is unique due to database primary key


# DELETE
def delete_execution(exec_id: str):
    try:
        execution = exec_dict.pop(exec_id)
        remove_player(execution.players)
    except KeyError:
        logging.error(f"{exec_id} already removed")


def remove_player(players):
    for player in players:
        try:
            registered_player.pop(player.tan)
        except KeyError:
            logging.info(f"{player.tan} already removed")
