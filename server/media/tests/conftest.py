import pytest

from app import create_app
from app_config import csrf, db

"""
If you’re using an application factory, define an app fixture to create and
configure an app instance. You can add code before and after the yield to set up
and tear down other resources, such as creating and clearing a database.
"""


@pytest.fixture()
def app():
    app = create_app(csrf=csrf, db=db)

    # Set up
    app.config.update({
        "TESTING": True,
    })

    yield app


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
