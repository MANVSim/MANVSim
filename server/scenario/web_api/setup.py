from flask import Flask

from scenario.web_api import scenario
from scenario.web_api.data import action


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment. """
    app.register_blueprint(scenario.web_api, url_prefix="/web")
    app.register_blueprint(action.web_api, url_prefix="/web/data")
