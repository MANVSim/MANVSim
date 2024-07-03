from flask_jwt_extended import get_jwt
from werkzeug.exceptions import NotFound

from execution import run
from execution.entities.execution import Execution


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


def try_get_execution(id: int) -> Execution:
    """
    Tries to return the execution from the runtime. If the execution does not exist a 404 Error is raised.

    :param id: ID of the execution
    :return: The execution object
    :raises NotFound: Error when execution does not exist
    """
    try:
        execution = run.active_executions[id]
    except KeyError:
        raise NotFound(f"Execution with id {id} does not exist")

    return execution
