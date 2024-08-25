import json

import models
from conftest import flask_app


def test_get_scenario(client):
    response = client.get("/web/scenario?scenario_id=2")
    response_data = response.get_json()
    assert response.status_code
    assert response_data["id"] == 2
    assert "name" in response_data.keys()
    assert "patients" in response_data.keys()
    assert "vehicles" in response_data.keys()


def test_create_scenario(client):

    response = client.get("/web/csrf")
    csrf_token = response.json["csrf_token"]
    csrf_header = {
        "X-CSRFToken": csrf_token
    }
    form = {
        "id": 2,
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
    response = client.patch("/web/scenario", data=json.dumps(form),
                            headers=csrf_header,
                            content_type='application/json')
    assert response.status_code == 200
    with flask_app.app_context():
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

