
def test_request_hello_world(client):
    response = client.get("/api/register/hello")
    assert response.status_code == 200
