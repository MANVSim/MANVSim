import json
from http import HTTPStatus

from conftest import generate_token


def test_player_inventory(client):
    auth_header = generate_token(client.application)

    response = client.get("/api/run/player/inventory", headers=auth_header)
    response_data = response.get_json()
    assert response.status_code == 200
    assert len(response_data["accessible_locations"]) > 0


def test_put_without_player_location(client):
    headers = generate_token(client.application)
    headers["Content-Type"] = "application/json"

    # leave location
    response = client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == HTTPStatus.OK

    form = {
        "put_location_ids": "[2]",
        "to_location_ids": "[5]"
    }

    response = client.post("/api/run/location/put-to", headers=headers,
                           data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK


def ttest_put_toplevel_inventory_location(client):
    # Disabled, because the test has IDE debugger use only.
    headers = generate_token(client.application)
    headers["Content-Type"] = "application/json"

    form = {
        "put_location_ids": "[1, 2]",
        "to_location_ids": "[5]"
    }

    response = client.post("/api/run/location/put-to", headers=headers,
                           data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK
    response_json_put = response.get_json()
    response_inventory = client.get("/api/run/player/inventory",
                                    headers=headers)
    assert response_inventory.status_code == HTTPStatus.OK
    response_json_inventory = response_inventory.get_json()
    assert response_json_inventory

