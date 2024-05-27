from executions import run
from executions.entities.execution import Execution

execution_ids = run.exec_dict.keys()
player_ids = run.registered_player.keys()


def test_request_hello_world(client):
    response = client.get("/api/register/hello")
    assert response.status_code == 200


def test_active_player(client):
    invalid_tan = "-1f"

    response = client.get(f"/api/register/{list(player_ids)[-1]}")
    assert response.status_code == 200
    assert response.json["exec_id"] in execution_ids

    response = client.get(f"/api/register/{invalid_tan}")
    assert response.status_code == 400


def test_current_exec_status(client):
    execution_id = list(execution_ids)[-1]
    invalid_id = "-1f"
    test_execution: Execution = run.exec_dict[execution_id]

    # status independent check
    response = client.get(f"/api/exec/status/{list(execution_ids)[-1]}")
    assert response.status_code == 200
    assert response.json["status"] == test_execution.status.name

    # status is RUNNING
    status_before = run.exec_dict[execution_id].status
    run.exec_dict[execution_id].status = Execution.Status.RUNNING
    response = client.get(f"/api/exec/status/{list(execution_ids)[-1]}")
    assert response.status_code == 200
    assert response.json["status"] == test_execution.status.name
    assert response.json["scenario"]["scn_id"] == test_execution.scenario.id
    run.exec_dict[execution_id].status = status_before

    # invalid id
    response = client.get(f"/api/exec/status/{invalid_id}")
    assert response.status_code == 400
