from execution import run
from conftest import generate_token


def test_get_notifications(api_client):
    auth_header = generate_token(api_client.application)
    execution = run.active_executions[2]

    messageA = "I am the first test-message."
    messageB = "I am the second test-message."
    messageC = "Why do we count test-messages. I am different."

    response = api_client.get("/api/notifications?next_id=0", headers=auth_header)
    assert response.status_code == 204

    execution.notifications.append(
        {
            "text": messageA,
            "timestamp": "empty"
        })
    execution.notifications.append(
        {
            "text": messageB,
            "timestamp": "empty"
        }
    )

    response = api_client.get("/api/notifications")
    assert response.status_code == 401

    response = api_client.get("/api/notifications", headers=auth_header)
    assert response.status_code == 400

    response = api_client.get("/api/notifications?next_id=200", headers=auth_header)
    assert response.status_code == 418

    response = api_client.get("/api/notifications?next_id=0", headers=auth_header)
    assert response.status_code == 200
    data = response.json
    assert len(data["notifications"]) == 2
    assert messageA in data["notifications"]
    assert messageB in data["notifications"]
    assert messageC not in data["notifications"]
    assert data["next_id"] == 2

    execution.notifications.append(
        {
            "text": messageC,
            "timestamp": "empty"
        }
    )
    response = api_client.get("/api/notifications?next_id=2", headers=auth_header)
    assert response.status_code == 200
    data = response.json
    assert len(data["notifications"]) == 1
    assert messageA not in data["notifications"]
    assert messageB not in data["notifications"]
    assert messageC in data["notifications"]
    assert data["next_id"] == 3

