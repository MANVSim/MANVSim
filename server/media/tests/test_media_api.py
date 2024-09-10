import http
import io

from conftest import generate_webtoken
from media.media_data import MediaData
from models import WebUser

TEST_IMG_1 = "media/static/image/rucksack_rot.jpg"
TEST_IMG_2 = "media/static/image/tasche_rot.jpg"


def test_get_static_media(client):
    # Test Image 1
    response = client.get(TEST_IMG_1)
    assert response.status_code == http.HTTPStatus.OK
    # Test Image 2
    response = client.get(TEST_IMG_2)
    assert response.status_code == http.HTTPStatus.OK


def test_post_instance_media_file(client):
    # Disable CSRF for this test
    client.application.config['WTF_CSRF_METHODS'] = []

    auth_header = generate_webtoken(client.application, WebUser.Role.SCENARIO_ADMIN)

    # Test post image
    with open(TEST_IMG_1, 'rb') as image_file:
        data = {
            "file": (io.BytesIO(image_file.read()), "test.jpg")
        }
        response = client.post("/web/media/test.jpg", headers=auth_header,
                               content_type="multipart/form-data", data=data)

    assert response.status_code == http.HTTPStatus.CREATED

    # Test access of posted image
    response = client.get("/media/instance/image/test.jpg")
    assert response.status_code == http.HTTPStatus.OK


def test_post_instance_media_file_with_attributes(client):
    # Disable CSRF for this test
    client.application.config['WTF_CSRF_METHODS'] = []

    auth_header = generate_webtoken(client.application, WebUser.Role.SCENARIO_ADMIN)

    # Test post image
    with open(TEST_IMG_1, 'rb') as image_file:
        data = {
            "file": (io.BytesIO(image_file.read()), "test.jpg"),
            "text": "Some test text.",
            "title": "The Title"
        }
        response = client.post("/web/media/test.jpg", headers=auth_header,
                               content_type="multipart/form-data", data=data)

    assert response.status_code == http.HTTPStatus.CREATED
    assert response.data
    assert MediaData.from_json(response.data).title == "The Title"
    assert MediaData.from_json(response.data).text == "Some test text."

    # Test access of posted image
    response = client.get("/media/instance/image/test.jpg")
    assert response.status_code == http.HTTPStatus.OK


def test_post_instance_media_text(client):
    # Disable CSRF for this test
    client.application.config['WTF_CSRF_METHODS'] = []

    auth_header = generate_webtoken(client.application, WebUser.Role.SCENARIO_ADMIN)
    response = client.post("/web/media/txt", headers=auth_header, content_type="multipart/form-data",
                           data={"text": "Test"})

    assert response.status_code == http.HTTPStatus.CREATED


def test_post_illegal_format(client):
    # Disable CSRF for this test
    client.application.config['WTF_CSRF_METHODS'] = []

    auth_header = generate_webtoken(client.application, WebUser.Role.SCENARIO_ADMIN)

    # Test post illegal data
    with open(__file__, 'rb') as illegal_file:
        data = {
            "file": (io.BytesIO(illegal_file.read()), "illegal.py")
        }
        response = client.post("/web/media/test.png", headers=auth_header,
                               content_type="multipart/form-data", data=data)

    assert response.status_code == http.HTTPStatus.BAD_REQUEST


def test_unauthorized_post(client):
    # Disable CSRF for this test
    client.application.config['WTF_CSRF_METHODS'] = []

    auth_header = generate_webtoken(client.application, WebUser.Role.GAME_MASTER)
    response = client.post("/web/media/txt", headers=auth_header, content_type="multipart/form-data",
                           data={"text": "Test"})

    assert response.status_code == http.HTTPStatus.FORBIDDEN


def test_illegal_get(client):
    response = client.get("media/static/../media.py")
    assert response.status_code == http.HTTPStatus.NOT_FOUND
    response = client.get("media/instance/../media.py")
    assert response.status_code == http.HTTPStatus.NOT_FOUND
