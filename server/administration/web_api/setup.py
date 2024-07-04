from flask import Flask
from flask_login import LoginManager

from administration.web_api import security, login
from models import WebUser


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment and configures a login manager. """

    login_manager = LoginManager()
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(username):
        return WebUser.get_by_username(username)

    app.register_blueprint(security.web_api, url_prefix="/web")
    app.register_blueprint(login.web_api, url_prefix="/web")
