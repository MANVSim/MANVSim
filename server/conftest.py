import jwt
import pytest

import dbsetup
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

# Create a Flask app with an in-memory SQLite database for testing
flask_app = create_app(csrf=csrf, db=db, db_uri='sqlite:///:memory:')

@pytest.fixture()
def fully_setup_app():
    """
    Configures a python app with in memory database. Further the dummy entities are loaded in memory.
    """
    # Configure testing mode
    flask_app.config.update({
        "TESTING": True,
    })

    # Create the database tables
    with flask_app.app_context():
        db.create_all()  # Create all tables for testing
        dbsetup.db_setup(app=flask_app, database=db)

    # Activate dummy executions
    run.activate_execution(dummy_entities.create_test_execution())
    run.activate_execution(dummy_entities.create_test_execution(pending=False))

    yield flask_app

    # Clean up
    with flask_app.app_context():
        db.session.remove()  # Remove the session
        db.drop_all()  # Drop all tables after the tests

    run.active_executions = {}

@pytest.fixture()
def db_app():
    """
    Configures a python app with in memory database only.
    """
    # Configure testing mode
    flask_app.config.update({
        "TESTING": True,
    })

    # Create the database tables
    with flask_app.app_context():
        db.create_all()  # Create all tables for testing
        dbsetup.db_setup(app=flask_app, database=db)

    yield flask_app

    # Clean up
    with flask_app.app_context():
        db.session.remove()  # Remove the session
        db.drop_all()  # Drop all tables after the tests

@pytest.fixture()
def entity_app():
    """
    The dummy entities are loaded in memory.
    """
    # Configure testing mode
    flask_app.config.update({
        "TESTING": True,
    })

    # Activate dummy executions
    run.activate_execution(dummy_entities.create_test_execution())
    run.activate_execution(dummy_entities.create_test_execution(pending=False))

    yield flask_app

    run.active_executions = {}



@pytest.fixture()
def api_client(entity_app):
    """ Returns a flask app with preloaded dummy-entities. """
    return entity_app.test_client()

@pytest.fixture()
def web_client(db_app):
    """ Returns a flask app with preloaded database. """
    return db_app.test_client()

@pytest.fixture()
def fully_setup_client(fully_setup_app):
    """ Returns a flask app with preloaded database and dummy-entities. """
    return fully_setup_app.test_client()


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
