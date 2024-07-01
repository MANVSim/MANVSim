from flask import Flask

from execution.web_api import notification, lobby


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment. """
    app.register_blueprint(notification.web_api, url_prefix="/web")
    app.register_blueprint(lobby.web_api, url_prefix="/web")
