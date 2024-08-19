from conftest import generate_token


def test_location_all(client):
    auth_header = generate_token(client.application)

    response = client.get("/api/run/player/inventory", headers=auth_header)
    response_data = response.get_json()
    assert response.status_code == 200
    assert len(response_data["accessible_locations"]) > 0
