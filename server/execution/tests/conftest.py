import jwt
import pytest

from app import create_app
from app_config import csrf, db
from execution import run
from execution.tests.entities.dummy_entities import create_test_execution

"""
If you’re using an application factory, define an app fixture to create and configure an app instance. 
You can add code before and after the yield to set up and tear down other resources, such as creating and clearing a 
database.
"""


@pytest.fixture()
def app():
    app = create_app(csrf=csrf, db=db)
    app.config.update({
        "TESTING": True,
    })

    # Set up
    test = create_test_execution()
    test.id = 2
    player_a = test.players.pop("123ABC")
    player_b = test.players.pop("456DEF")
    player_a.tan = "987ZYX"
    player_b.tan = "654WVU"
    test.players["987ZYX"] = player_a
    test.players["654WVU"] = player_b
    exec_before = len(run.active_executions)
    player_before = len(run.registered_players)
    run.activate_execution(test)

    assert len(run.active_executions) == exec_before + 1
    assert len(run.registered_players) == player_before + len(test.players)

    yield app

    # Clean up
    run.deactivate_execution(test.id)
    assert len(run.active_executions) == exec_before
    assert len(run.registered_players) == player_before


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()


def generate_token(app, valid_payload=True, running=False):
    payload = {
        "sub": ("123ABC" if running else "654WVU"),
        "exec_id": ("1" if running else "2"),
    }
    payload_invalid = {
        "sub": "123ABC",
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
