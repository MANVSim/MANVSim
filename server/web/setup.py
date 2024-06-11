from flask import Flask
from flask_login import LoginManager
from models import WebUser
from app import db
from .api.register import api
from bcrypt import gensalt, hashpw


def setup(app: Flask):
    # TODO: Remove
    with app.app_context():
        if WebUser.get_by_username("Terra") is None:
            terra = WebUser(username="Terra",
                            password=hashpw(b"pw1234", gensalt()).decode())
            db.session.add(terra)
            db.session.commit()

    app.register_blueprint(api, url_prefix="/web")

    login_manager = LoginManager()
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(username):
        return WebUser.get_by_username(username)

    app.config["JWT_ACCESS_TOKEN_EXPIRES"] = False  # TODO: Remove
