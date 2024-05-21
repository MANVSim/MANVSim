from executions import run
from executions.api import api

from flask import request, Response
from flask_api import status


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


@api.get("register/hello")
def hello_world():
    return {"hello": "world"}


@api.post("register")
def register_player():
    try:
        exec_id = run.active_player[request.form["TAN"]]
        return {"exec_id": exec_id}
    except KeyError:
        print("ERROR: invalid tan detected. Unable to resolve player.")
        return Response(status=status.HTTP_400_BAD_REQUEST)
