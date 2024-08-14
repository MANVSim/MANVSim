from flask import Flask

from scenario.web_api import scenario
from scenario.web_api import patient


def setup(app: Flask):
    """Connects each implemented endpoint to flask environment."""
    app.register_blueprint(scenario.web_api, url_prefix="/web")
    app.register_blueprint(patient.blueprint, url_prefix="/web/patient")
