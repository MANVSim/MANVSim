from flask import Flask

from scenario.web_api import scenario
from scenario.web_api.data import action, location, resource, patient
from app_config import csrf


def setup(app: Flask):
    """Connects each implemented endpoint to flask environment."""
    app.register_blueprint(scenario.web_api, url_prefix="/web")
    app.register_blueprint(action.web_api, url_prefix="/web/data")
    app.register_blueprint(location.web_api, url_prefix="/web/data")
    app.register_blueprint(resource.web_api, url_prefix="/web/data")
    app.register_blueprint(patient.web_api, url_prefix="/web/data")
    csrf.exempt(scenario.web_api)
