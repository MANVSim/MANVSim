import json

from execution import run
from execution.entities.execution import Execution
from conftest import generate_token

execution_ids = run.active_executions.keys()
player_ids = run.registered_players.keys()


def test_active_player(api_client):
    invalid_tan = "-1f"
    form = {
        "TAN": list(player_ids)[-1]
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = api_client.post(f"/api/login", data=json.dumps(form), headers=headers)
    assert response.status_code == 200
    assert response.json["jwt_token"] != ""
    assert response.json["csrf_token"] != ""

    form = {
        "TAN": invalid_tan
    }
    response = api_client.post(f"/api/login", json.dumps(form), headers=headers)
    assert response.status_code == 400


def test_current_exec_status(api_client):
    execution_id = list(execution_ids)[-1]
    test_execution: Execution = run.active_executions[execution_id]
    headers = generate_token(api_client.application, pending=True)
    headers_invalid_payload = generate_token(api_client.application, valid_payload=False)

    # status independent check
    response = api_client.get("/api/scenario/start-time", headers=headers)
    assert response.status_code == 204

    # status is RUNNING
    headers = generate_token(api_client.application)
    response = api_client.get("/api/scenario/start-time", headers=headers)
    assert response.status_code == 200
    assert response.json["starting_time"] == test_execution.starting_time

    assert response.json["arrival_time"] > run.active_executions[2].players["654WVU"].activation_delay_sec

    # invalid id
    response = api_client.get("/api/scenario/start-time", headers=headers_invalid_payload)
    assert response.status_code == 400


def test_set_name(api_client):
    player_id = "123ABC"
    exec_id = run.registered_players[player_id]
    execution = run.active_executions[exec_id]
    player = execution.players[player_id]

    auth_header = generate_token(api_client.application, pending=True)
    auth_header["Content-Type"] = "application/json"
    # initial set-name
    form = {
        "name": "Test-User"
    }
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 200
    assert player.name == "Test-User"

    # invalid set-name due to already existing string
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 409

    # forcing the set name to succeed
    form = {
        "name": "Test-User-v2",
        "force_update": "True"
    }
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 200

    # set wrong force flag
    form = {
        "name": "Test-User-v3",
        "force_update": "False"
    }
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 409

    # set invalid force key with True
    form = {
        "name": "Test-User-v4",
        "force_update-invalid-key": "True"
    }
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 409

    # invalid name key
    form = {
        "name-invalid-key": "Test-User-v5"
    }
    response = api_client.post("/api/player/set-name", data=json.dumps(form), headers=auth_header)
    assert response.status_code == 400

    assert player.name == "Test-User-v2"
