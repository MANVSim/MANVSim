from django.urls import path
from ..views import register, security

urlpatterns = [
    path('register/hello/', register.hello_world),
    path('register/', register.register_player),

    path('security/csrf/', security.csrf)
]
