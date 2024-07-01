import http
import json
import time

from execution import run
from execution.entities.location import Location
from execution.tests.conftest import generate_token

player_ids = run.registered_players.keys()


def test_perform_action(client):
    """
    INTEGRATION TEST

    This test assumes the player executing the tasks has all resources required in his inventory.
    The test simulates the arrival on a patient and performing an EKG action and checks the result afterward.
    Further a second player tries to perform an action while a resource is taken due to an ongoing action of
    player 1. After the duration time both player are able to get either their result or perform the desired action
    on their own.
    """
    # Player 1
    headers = generate_token(client.application)
    headers["Content-Type"] = "application/json"
    # Player 2
    headers_p2 = generate_token(client.application)
    headers_p2["Content-Type"] = "application/json"

    # Player 1: leave location
    response = client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == http.HTTPStatus.OK

    # Player 1: arrive at patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK

    # Player 1: perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK
    id = response.json["performed_action_id"]

    # Player 2: leave location
    response = client.post("/api/run/location/leave", headers=headers_p2)
    assert response.status_code == http.HTTPStatus.OK

    # Player 2: arrive at patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers_p2, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK

    # Player 2: perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers_p2, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.CONFLICT
    assert response.text == "Resource is not available"

    # Player 1: check for result
    response = client.get(f"/api/run/action/perform/result?performed_action_id={id}&patient_id=1", headers=headers)
    assert response.status_code == http.HTTPStatus.OK
    response_json = response.json
    assert "conditions" in response_json
    assert "EKG" in response_json["conditions"]

    patient = response.json["patient"]
    performed_action = list(patient["performed_actions"])
    assert len(performed_action) > 1    # patient already got a performed action

    time.sleep(2)  # wait action duration

    # Player 2: perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers_p2, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK
    id = response.json["performed_action_id"]

    # Player 2: check for result
    response = client.get(f"/api/run/action/perform/result?performed_action_id={id}&patient_id=1", headers=headers_p2)
    assert response.status_code == http.HTTPStatus.OK
    patient = response.json["patient"]
    performed_action = list(patient["performed_actions"])
    assert len(performed_action) > 2


def test_perform_action_but_blocked_to_leaving(client):
    """
    INTEGRATION TEST

    This test assumes the player executing the tasks has all resources required in his inventory.
    The test simulates the arrival on a patient and performing an EKG action. However, the resource is marked for
    leaving beforehand. Therefor not action is enqueued.
    """
    # Setup
    execution = run.active_executions[2]
    locations = list(execution.scenario.locations.values())
    location: Location = locations[3]  # EKG

    # Login
    form = {
        "TAN": list(player_ids)[-1]
    }
    headers = generate_token(client.application)
    headers["Content-Type"] = "application/json"
    response = client.post(f"/api/login", data=json.dumps(form), headers=headers)
    assert response.status_code == http.HTTPStatus.OK

    # leave location
    response = client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == http.HTTPStatus.OK

    # arrive patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK

    # simulate leaving on the location
    location.res_lock.acquire()
    # perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.CONFLICT
    location.res_lock.release()
