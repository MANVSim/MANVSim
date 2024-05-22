import logging

from executions.entities.execution import Execution
from executions.entities.player import Player
from executions.entities.scenario import Scenario

"""
This file is the main execution module file. It contains all valid methods to create a scenario-game
along with scenario-state-changing methods. It uses DBO instances of the web-module and logs any
action of interest into a separate file (FIXME: docu update @Louis)
"""

# TEST DATA
player_a = Player("69", "Finn Bartels", None, [])
player_b = Player("88", "Fiete Arp", None, [])

test_a = Execution(1337, Scenario(17, "Test-Scenario-Pending", [], [], {}), 42, [player_a], Execution.Status.PENDING)
test_b = Execution(1338, Scenario(18, "Test-Scenario-Running", [],[], {}), 42, [player_b], Execution.Status.RUNNING)

# Dictionary storing the current available execution, whether they are PENDING, RUNNING or about to FINISH
exec_dict = {
    # "exec_id": "exec: execution_dbo"
    "1337": test_a,
    "1338": test_b,
}

# Dictionary storing all active players in an execution
active_player = {
    # "TAN" : "exec_uuid"
    "69": "1337",
    "88": "1338",
}


# CREATE
def create_execution(execution: Execution):
    exec_id = str(execution.id)  # exec id is unique due to database primary key
    exec_dict[exec_id] = execution
    create_active_players(exec_id, execution.players)


def create_active_players(exec_id, players):
    for player in players:
        active_player[player.tan] = str(exec_id)  # player_tan is unique due to database primary key


# DELETE
def delete_execution(exec_id: str):
    try:
        execution = exec_dict.pop(exec_id)
        delete_active_players(execution.players)
    except KeyError:
        logging.error(f"{exec_id} already removed")


def delete_active_players(players):
    for player in players:
        try:
            active_player.pop(player.tan)
        except KeyError:
            logging.info(f"{player.tan} already removed")
