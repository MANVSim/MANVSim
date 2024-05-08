import logging

from django.http import JsonResponse, HttpRequest, HttpResponse
from http import HTTPStatus

from django.utils.datastructures import MultiValueDictKeyError


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
        tan = data["TAN"]
        logging.debug(f"Player registered with data: {tan}")
        # TODO
        response.status_code = HTTPStatus.OK
        return response

    except MultiValueDictKeyError:
        response.status_code = HTTPStatus.BAD_REQUEST
        return response
