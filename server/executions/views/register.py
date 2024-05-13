from django.http import JsonResponse, HttpRequest, HttpResponse
from http import HTTPStatus

from django.utils.datastructures import MultiValueDictKeyError

from executions import run


def hello_world(_):
    data = {"hello": "world"}
    return JsonResponse(data)


def register_player(request: HttpRequest):
    response = HttpResponse()
    if request.method != "POST":
        response.status_code = HTTPStatus.BAD_REQUEST
        return response

    try:
        data = request.POST
        execution = run.get_execution_by_player_tan(data["TAN"])

        return JsonResponse({"execution-status": execution.status.name})

    except MultiValueDictKeyError:
        response.status_code = HTTPStatus.BAD_REQUEST
        return response


def get_current_exec_status(request, exec_id: str):
    """
        A method to check on the current status. If the execution is set to status running the response contains
        a scenario id and name to continue further progress. Otherwise, only the current status
    """
    if request.method != "GET":
        response = HttpResponse()
        response.status_code = HTTPStatus.BAD_REQUEST
        return response

    try:
        execution = run.exec_dict[exec_id]
        if execution.status == execution.Status.RUNNING:
            data = {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time,
                "scenario": {
                    "scn_id": execution.scenario.id,
                    "scn_name": execution.scenario.name
                }
            }
            return JsonResponse(data)
        else:
            data = {
                "exec_id": exec_id,
                "status": execution.status.name,
                "starting_time": execution.starting_time
            }
            return JsonResponse(data)
    except KeyError:
        response = HttpResponse()
        response.status_code = HTTPStatus.BAD_REQUEST
        response.write(content="Invalid execution id provided. Unable to retrieve execution data.")
        return response


