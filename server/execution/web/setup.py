from flask import Flask

from execution.web.notification import web_api


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment. """
    app.register_blueprint(web_api, url_prefix="/web")
