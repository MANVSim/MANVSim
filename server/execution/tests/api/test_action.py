import json
import time

from execution import run
from http import HTTPStatus
from execution.entities.location import Location
from execution.tests.conftest import generate_token

player_ids = run.registered_players.keys()


def test_get_actions(client):
    auth_header = generate_token(client.application, pending=False, plid="987ZYX")
    response = client.get("/api/run/action/all", headers=auth_header)
    assert response.status_code == HTTPStatus.OK
    actions = response.json["actions"]
    assert False not in [action["required_role"] <= 200 for action in actions]


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
    assert response.status_code == HTTPStatus.OK

    # Player 1: arrive at patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers, data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK

    # Player 1: perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK
    id = response.json["performed_action_id"]

    # Player 2: leave location
    response = client.post("/api/run/location/leave", headers=headers_p2)
    assert response.status_code == HTTPStatus.OK

    # Player 2: arrive at patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers_p2, data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK

    # Player 2: perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers_p2, data=json.dumps(form))
    assert response.status_code == HTTPStatus.CONFLICT
    assert response.text == "Resource is not available"

    # Player 1: check for result
    response = client.get(f"/api/run/action/perform/result?performed_action_id={id}&patient_id=1", headers=headers)
    assert response.status_code == HTTPStatus.OK
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
    assert response.status_code == HTTPStatus.OK
    id = response.json["performed_action_id"]

    # Player 2: check for result
    response = client.get(f"/api/run/action/perform/result?performed_action_id={id}&patient_id=1", headers=headers_p2)
    assert response.status_code == HTTPStatus.OK
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
    assert response.status_code == HTTPStatus.OK

    # leave location
    response = client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == HTTPStatus.OK

    # arrive patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers, data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK

    # simulate leaving on the location
    location.res_lock.acquire()
    # perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=json.dumps(form))
    assert response.status_code == HTTPStatus.CONFLICT
    location.res_lock.release()


def test_move_patient(client):
    auth_token = generate_token(client.application)
    auth_token["Content-Type"] = "application/json"
    patient_id = 1
    new_location_id = 1

    form = {
        "patient_id": patient_id,
        "new_location_id": new_location_id
    }
    execution = run.active_executions[2]
    patient = execution.scenario.patients[patient_id]

    # -- Before
    assert patient.id in execution.scenario.patients.keys()
    assert patient.location.id in execution.scenario.locations.keys()

    # -- Fail Request: move patient out of reachability of player
    response = client.post("/api/run/action/perform/move/patient",
                           headers=auth_token, data=json.dumps(form))
    assert response.status_code == 418
    assert patient.location.id != new_location_id

    # -- Prevent fail request
    response = client.post("/api/run/location/leave", headers=auth_token)
    assert response.status_code == HTTPStatus.OK
    response = client.post("/api/run/patient/arrive", headers=auth_token, data=json.dumps(form))
    assert response.status_code == HTTPStatus.OK

    # -- Fail Request: try move with invalid data
    invalid_form = {
        "patient_id": -1,
        "new_location_id": new_location_id
    }
    response = client.post("/api/run/action/perform/move/patient",
                           headers=auth_token, data=json.dumps(invalid_form))
    assert response.status_code == 400
    assert patient.location.id != new_location_id

    invalid_form = {
        "patient_id": patient_id,
        "new_location_id": -1
    }
    response = client.post("/api/run/action/perform/move/patient",
                           headers=auth_token, data=json.dumps(invalid_form))
    assert response.status_code == 400
    assert patient.location.id != new_location_id

    # Successful request
    old_location = patient.location
    response = client.post("/api/run/action/perform/move/patient",
                           headers=auth_token, data=json.dumps(form))
    assert response.status_code == 200
    assert patient.location.id == new_location_id
    assert old_location.id in execution.scenario.locations.keys()

