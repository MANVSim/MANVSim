import http
import json

from execution import run
from execution.entities.location import Location
from execution.tests.conftest import generate_token

player_ids = run.registered_player.keys()


def test_perform_action(client):
    """
    INTEGRATION TEST

    This test assumes the player executing the tasks has all resources required in his inventory.
    The test simulates the arrival on a patient and performing an EKG action and checks the result afterward.
    """
    # Login
    form = {
        "TAN": list(player_ids)[-1]
    }
    headers = generate_token(client.application, running=True)
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

    # perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=json.dumps(form))
    assert response.status_code == http.HTTPStatus.OK

    # check for result
    id = response.json["performed_action_id"]
    response = client.get(f"/api/run/action/perform/result?performed_action_id={id}&patient_id=1", headers=headers)
    assert response.status_code == http.HTTPStatus.OK
    patient = response.json["patient"]
    performed_action = list(patient["performed_actions"])
    assert len(performed_action) > 0


def test_perform_action_but_blocked_to_leaving(client):
    """
    INTEGRATION TEST

    This test assumes the player executing the tasks has all resources required in his inventory.
    The test simulates the arrival on a patient and performing an EKG action. However the resource is marked for leaving
    beforehand. Therefor not action is enqueued.
    """
    # Setup
    execution = run.exec_dict["2"]
    locations = list(execution.scenario.locations.values())
    location: Location = locations[3]  # EKG

    # Login
    form = {
        "TAN": list(player_ids)[-1]
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = client.post(f"/api/login", data=json.dumps(form), headers=headers)
    assert response.status_code == http.HTTPStatus.OK
    headers = generate_token(client.application, running=True)
    headers["X-CSRFToken"] = response.json["csrf_token"]

    # leave location
    response = client.post("/api/run/location/leave", headers=headers)
    assert response.status_code == http.HTTPStatus.OK

    # arrive patient
    form = {
        "patient_id": 1,
    }
    response = client.post("/api/run/patient/arrive", headers=headers, data=form)
    assert response.status_code == http.HTTPStatus.OK

    # simulate leaving on the location
    location.res_lock.acquire()
    # perform action
    form = {
        "action_id": 1,
        "patient_id": 1,
        "resources": [1]
    }
    response = client.post("/api/run/action/perform", headers=headers, data=form)
    assert response.status_code == http.HTTPStatus.CONFLICT
    location.res_lock.release()
