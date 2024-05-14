from django.urls import path
from ..views import register, security

urlpatterns = [
    path('exec/status/<str:exec_id>', register.get_current_exec_status),

    path('register/hello/', register.hello_world),
    path('register/', register.register_player),

    path('security/csrf/', security.csrf)
]
