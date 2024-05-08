from django.http import JsonResponse
from django.shortcuts import render


def hello_world(request):
    data = {"hello": "world"}
    return JsonResponse(data)
