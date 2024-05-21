import pytest
from app import create_app

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

    # other setup can go here

    yield app

    # clean up / reset resources here


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
