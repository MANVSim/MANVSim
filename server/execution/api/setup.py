from flask import Flask

from execution.api import lobby, notification, patient, location, action


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment. """
    app.register_blueprint(lobby.api, url_prefix="/api")
    app.register_blueprint(notification.api, url_prefix="/api")
    app.register_blueprint(patient.api, url_prefix="/api/run")
    app.register_blueprint(location.api, url_prefix="/api/run")
    app.register_blueprint(action.api, url_prefix="/api/run")
