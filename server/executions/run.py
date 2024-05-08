from executions.entities.execution import Execution
from executions.entities.scenario import Scenario

"""
This file is the main execution module file. It contains all valid methods to create a scenario-game
along with scenario-state-changing methods. It uses DBO instances of the web-module and logs any
action of interest into a separate file (FIXME: docu update @Louis)
"""

test = Execution(1337, Scenario(17, "Test", []), 42, [], Execution.Status.PENDING)

# Dictionary storing the current available execution, whether they are PENDING, RUNNING or about to FINISH
exec_dict = {
    # "exec_id": "exec: execution_dbo"
    1337: test
}

# Dictionary storing all active players in an execution
active_player = {
    # "TAN" : "exec_uuid"
    "69": 1337
}


# CREATE
def create_execution(execution: Execution):
    exec_id = execution.id  # exec id is unique due to database primary key
    exec_dict[exec_id] = execution
    create_active_players(exec_id, execution.players)


def create_active_players(exec_id, players):
    for player in players:
        active_player[player.tan] = exec_id  # player_tan is unique due to database primary key


# READ
def get_execution_by_player_tan(tan):
    try:
        exec_id = active_player[tan]
        return exec_dict[exec_id]
    except KeyError:
        print(f"ERROR: invalid tan or exec_id detected. No registered player/execution.")


# DELETE
def delete_execution(exec_id):
    try:
        execution = exec_dict.pop(exec_id)
        delete_active_players(execution.players)
    except KeyError:
        print(f"ERROR: {exec_id} already removed")


def delete_active_players(players):
    for player in players:
        try:
            active_player.pop(player.tan)
        except KeyError:
            print(f"{player.tan} already removed")
