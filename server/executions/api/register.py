import logging

from executions import run
from executions.api import api

from flask import Response
from flask_api import status
from flask_wtf.csrf import generate_csrf


@api.get("/exec/status/<exec_id>")
def get_current_exec_status(exec_id: str):
    """
    A method to check on the current status. If the execution is set to status running the response contains
    a scenario id and name to continue further progress. Otherwise, only the current status
    """
    try:
        execution = run.exec_dict[exec_id]
        if execution.status == execution.Status.RUNNING:
            return {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time,
                "scenario": {
                    "scn_id": execution.scenario.id,
                    "scn_name": execution.scenario.name,
                },
            }
        else:
            return {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time,
            }
    except KeyError:
        return Response(
            response="Invalid execution id provided. Unable to resolve execution data.",
            status=status.HTTP_400_BAD_REQUEST,
        )


@api.get("/register/hello")
def hello_world():
    return {"hello": "world"}


@api.get("/register/<tan>")
def register_player(tan: str):
    try:
        exec_id = run.active_player[tan]
        return {"exec_id": exec_id, "csrf_token": generate_csrf()}
    except KeyError:
        logging.error("invalid tan detected. Unable to resolve player.")
        return Response(
            response="Invalid TAN detected. Unable to resolve player.",
            status=status.HTTP_400_BAD_REQUEST,
        )
