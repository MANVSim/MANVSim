from conftest import generate_token


def test_request_on_pending_execution(api_client):
    auth_header = generate_token(app=api_client.application, pending=True)

    response = api_client.get("/api/run/action/all", headers=auth_header)
    assert response.status_code == 204
    response = api_client.get("/api/run/location/all", headers=auth_header)
    assert response.status_code == 204
    response = api_client.get("/api/run/patient/all-ids", headers=auth_header)
    assert response.status_code == 204

    auth_header = generate_token(app=api_client.application)

    response = api_client.get("/api/run/action/all", headers=auth_header)
    assert response.status_code == 200
    response = api_client.get("/api/run/location/all", headers=auth_header)
    assert response.status_code == 200
    response = api_client.get("/api/run/patient/all-ids", headers=auth_header)
    assert response.status_code == 200
