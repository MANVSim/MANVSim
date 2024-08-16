import jwt
import pytest

from app import create_app
from app_config import csrf, db
from execution import run
from execution.tests.entities import dummy_entities
from models import WebUser

"""
If you’re using an application factory, define an app fixture to create and configure an app instance.
You can add code before and after the yield to set up and tear down other resources, such as creating and clearing a
database.
"""

flask_app = create_app(csrf=csrf, db=db)


@pytest.fixture()
def app():

    # Set up
    flask_app.config.update({
        "TESTING": True,
    })
    run.activate_execution(dummy_entities.create_test_execution())
    run.activate_execution(dummy_entities.create_test_execution(pending=False))

    yield flask_app

    # Clean up
    run.active_executions = {}


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()


def generate_token(app, valid_payload=True, pending=False, plid="123ABC"):
    payload = {
        "sub": (plid if pending or plid != "123ABC" else "654WVU"),
        "exec_id": ("1" if pending else "2"),
    }
    payload_invalid = {
        "sub": plid,
        "exec_id": "-1",
    }
    if valid_payload:
        return {
            "Authorization": f"Bearer {jwt.encode(payload, app.config["JWT_SECRET_KEY"], algorithm="HS256")}"
        }
    else:
        return {
            "Authorization": f"Bearer {jwt.encode(payload_invalid, app.config["JWT_SECRET_KEY"], algorithm="HS256")}"
        }


def generate_webtoken(app, identity: WebUser.Role = WebUser.Role.GAME_MASTER):
    payload = {
        # This is the custom claim added by flask_jwt_extended which holds the
        # value of the identity parameter passed during token creation.
        "identity": identity.name,
        # This is the standard JWT claim (subject) which also holds the value
        # of the identity parameter. This is where flask_jwt_extended places the
        # identity by default.
        "sub": identity.name
    }
    return {"Authorization": f"Bearer {jwt.encode(payload,
                                                  app.config["JWT_SECRET_KEY"],
                                                  algorithm="HS256")}"}
