from django.urls import path
from . import views


urlpatterns = [
    path("scenarios/", views.scenarios, name="scenarios"),
    path("scenarios/start", views.start, name="start"),
    path("scenarios/end/<str:scn_id>", views.end, name="end")
]
