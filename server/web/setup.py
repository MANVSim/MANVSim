from flask import Flask
from .api.register import api


def setup(app: Flask):
    app.register_blueprint(api, url_prefix="/api/web")
