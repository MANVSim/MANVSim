from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


def create_app():
    """
    Creat the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    from web.api import api

    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"

    db.init_app(app)

    app.register_blueprint(api, url_prefix="/api")

    return app
