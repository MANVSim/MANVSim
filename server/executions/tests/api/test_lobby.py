import json

from executions import run
from executions.entities.execution import Execution
from executions.tests.conftest import generate_token

execution_ids = run.exec_dict.keys()
player_ids = run.registered_player.keys()


def test_active_player(client):
    invalid_tan = "-1f"
    form = {
        "TAN": list(player_ids)[-1]
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = client.post(f"/api/login", data=json.dumps(form), headers=headers)
    assert response.status_code == 200
    assert response.json["jwt_token"] != ""
    assert response.json["csrf_token"] != ""

    form = {
        "TAN": invalid_tan
    }
    response = client.post(f"/api/login", json.dumps(form), headers=headers)
    assert response.status_code == 400


def test_current_exec_status(client):
    execution_id = list(execution_ids)[-1]
    test_execution: Execution = run.exec_dict[execution_id]
    headers = generate_token(client.application)
    headers_invalid_payload = generate_token(client.application, valid_payload=False)

    # status independent check
    response = client.get("/api/scenario/start-time", headers=headers)
    assert response.status_code == 204

    # status is RUNNING
    headers = generate_token(client.application, running=True)
    response = client.get("/api/scenario/start-time", headers=headers)
    assert response.status_code == 200
    assert response.json["starting_time"] == test_execution.starting_time

    # Requires testing for an alerted player. Not yet implemented due to mutation bug.
    # assert response.json["travel_time"] > -1

    # invalid id
    response = client.get("/api/scenario/start-time", headers=headers_invalid_payload)
    assert response.status_code == 400
