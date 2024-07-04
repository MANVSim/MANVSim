from execution.tests.conftest import generate_token


def test_request_on_pending_execution(client):
    auth_header = generate_token(app=client.application, pending=True)

    response = client.get("/api/run/action/all", headers=auth_header)
    assert response.status_code == 204
    response = client.get("/api/run/location/all", headers=auth_header)
    assert response.status_code == 204
    response = client.get("/api/run/patient/all-tans", headers=auth_header)
    assert response.status_code == 204

    auth_header = generate_token(app=client.application)

    response = client.get("/api/run/action/all", headers=auth_header)
    assert response.status_code == 200
    response = client.get("/api/run/location/all", headers=auth_header)
    assert response.status_code == 200
    response = client.get("/api/run/patient/all-tans", headers=auth_header)
    assert response.status_code == 200
