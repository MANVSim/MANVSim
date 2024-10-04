import json
from http import HTTPStatus

from conftest import generate_token


def test_player_inventory(api_client):
    auth_header = generate_token(api_client.application)

    response = api_client.get("/api/run/player/inventory", headers=auth_header)
    response_data = response.get_json()
    assert response.status_code == 200
    assert len(response_data["accessible_locations"]) > 0


def test_put_without_player_location(fully_setup_client):
    headers = generate_token(fully_setup_client.application)
    headers["Content-Type"] = "application/json"

    # leave location
    response = fully_setup_client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == HTTPStatus.OK

    form = {
        "put_location_ids": "[2]",
        "to_location_ids": "[5]"
    }

    response = fully_setup_client.post("/api/run/location/put-to", headers=headers,
                           data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK


def ttest_put_toplevel_inventory_location(fully_setup_client):
    # Disabled, because the test has IDE debugger use only.
    headers = generate_token(fully_setup_client.application)
    headers["Content-Type"] = "application/json"

    form = {
        "put_location_ids": "[1, 2]",
        "to_location_ids": "[5]"
    }

    response = fully_setup_client.post("/api/run/location/put-to", headers=headers,
                           data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK
    response_inventory = fully_setup_client.get("/api/run/player/inventory",
                                    headers=headers)
    assert response_inventory.status_code == HTTPStatus.OK

