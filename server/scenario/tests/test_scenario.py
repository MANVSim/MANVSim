import json

import models
from conftest import flask_app

"""
Tests are deactivated, because they are designed for Debugging Cases in IDE.
They are not appliable for pipeline.
"""

def ttest_get_scenario(web_client):
    response = web_client.get("/web/scenario?scenario_id=2")
    response_data = response.get_json()
    assert response.status_code
    assert response_data["id"] == 2
    assert "name" in response_data.keys()
    assert "patients" in response_data.keys()
    assert "vehicles" in response_data.keys()


def ttest_add_vehicle_to_scenario(web_client):

    response = web_client.get("/web/csrf")
    csrf_token = response.json["csrf_token"]
    csrf_header = {
        "X-CSRFToken": csrf_token
    }

    form = {
        "id": 1,
        "vehicles_add": [
            {
                "id": 0,
                "name": "RTW I-0"
            },
            {
                "id": 0,
                "name": "RTW I-1"
            },

        ],
        "vehicles_del": [],
    }

    response = web_client.patch("/web/scenario", data=json.dumps(form),
                            headers=csrf_header,
                            content_type='application/json')

    assert response.status_code == 200


def ttest_create_scenario(web_client):

    response = web_client.get("/web/csrf")
    csrf_token = response.json["csrf_token"]
    csrf_header = {
        "X-CSRFToken": csrf_token
    }
    form = {
        "id": 1,
        "name": "neuer Name",
        "vehicles_add": [
            {
                "id": 0,
                "name": "RTW II"
            },
            {
                "id": 0,
                "name": "RTW III"
            },
        ],
        "vehicles_del": [
            {
                "id": 0,
                "name": "RTW II"
            },
        ],
    }
    response = web_client.patch("/web/scenario", data=json.dumps(form),
                            headers=csrf_header,
                            content_type='application/json')
    assert response.status_code == 200
    with flask_app.app_context():
        zero_vehicles = models.PlayersToVehicleInExecution.query.filter_by(
            execution_id=0,
        ).all()
        vehicle = models.PlayersToVehicleInExecution.query.filter_by(
            scenario_id=2,
            location_id=0,
            vehicle_name="RTW II"
        ).first()
        assert vehicle
        vehicle = models.PlayersToVehicleInExecution.query.filter_by(
            vehicle_name="RTW III"
        ).all()
        assert len(vehicle) > 1

