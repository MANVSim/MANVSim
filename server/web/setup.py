from flask import Flask
from flask_login import LoginManager
from models import WebUser
from .api.register import api


def setup(app: Flask):
    app.register_blueprint(api, url_prefix="/web")

    login_manager = LoginManager()
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(username):
        return WebUser.get_by_username(username)

    app.config["JWT_ACCESS_TOKEN_EXPIRES"] = False  # TODO: Remove
