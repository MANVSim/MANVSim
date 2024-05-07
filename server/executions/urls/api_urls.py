from django.urls import path
from ..views import register

urlpatterns = [
    path('register/hello/', register.hello_world)
]