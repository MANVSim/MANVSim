import logging

from django.http import JsonResponse, HttpRequest, HttpResponse
from http import HTTPStatus

from django.utils.datastructures import MultiValueDictKeyError

from executions import run


def hello_world(request):
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
