from flask_jwt_extended import get_jwt

from executions import run


def get_param_from_jwt(param):
    claims = get_jwt()
    return claims[param]


def get_execution_and_player():
    """ Returns the current execution instance as well as the player referenced by TAN"""
    exec_id = get_param_from_jwt("exec_id")
    tan = get_param_from_jwt("TAN")
    execution = run.exec_dict[exec_id]
    player = execution.get_player_by_tan(tan)

    return execution, player
