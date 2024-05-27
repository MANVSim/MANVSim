import pytest

from app import create_app
from executions import run
from executions.tests.dummy_entities import create_test_execution

"""
If you’re using an application factory, define an app fixture to create and configure an app instance. 
You can add code before and after the yield to set up and tear down other resources, such as creating and clearing a 
database.
"""


@pytest.fixture()
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
    })

    # Set up
    test_execution = create_test_execution()
    exec_before = len(run.exec_dict)
    player_before = len(run.registered_player)
    run.create_execution(test_execution)

    assert len(run.exec_dict) == exec_before + 1
    assert len(run.registered_player) == player_before + len(test_execution.players)

    yield app

    # Clean up
    run.delete_execution(str(test_execution.id))
    assert len(run.exec_dict) == exec_before
    assert len(run.registered_player) == player_before


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
