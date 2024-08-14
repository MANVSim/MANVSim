import json


def test_get_scenario(client):
    response = client.get("/web/scenario?scenario_id=2")
    response_data = response.get_json()
    assert response.status_code
    assert response_data["id"] == 2
    assert "name" in response_data.keys()
    assert "patients" in response_data.keys()
    assert "vehicles" in response_data.keys()
    assert "vehicles-quantity" in response_data.keys()


def test_create_scenario(client):

    response = client.get("/web/csrf")
    csrf_token = response.json["csrf_token"]
    csrf_header = {
        "X-CSRFToken": csrf_token
    }
    form = {
        "id": 2,
        "name": "neuer Name",
        "patients": [
            {
                "id": 0,
                "quantity": 0
            },
            {
                "id": 1,
                "quantity": 3
            },
            {
                # might cause error
                "id": 245,
                "quantity": 1
            }
        ],
        "vehicle": []
    }
    response = client.patch("/web/scenario", data=json.dumps(form),
                            headers=csrf_header,
                            content_type='application/json')
    assert response.status_code == 200

