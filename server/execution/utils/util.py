from flask_jwt_extended import get_jwt

from execution import run


def __get_param_from_jwt(param):
    claims = get_jwt()
    return claims[param]


def get_execution_and_player():
    """ Returns the current execution instance as well as the player referenced by TAN"""
    exec_id = int(__get_param_from_jwt("exec_id"))
    tan = __get_param_from_jwt("sub")
    execution = run.active_executions[exec_id]
    player = execution.players[tan]

    return execution, player
