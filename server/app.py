import os
from flask import Flask, send_from_directory, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import CSRFProtect

db = SQLAlchemy()
csrf = CSRFProtect()


def create_app():
    """
    Creat the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    from web.api import api

    app = Flask(__name__, static_folder="manvsim-frontend/build")
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"

    db.init_app(app)
    csrf.init_app(app)

    # register paths required for serving frontend
    @app.route("/", defaults={"path": ""})
    @app.route("/<path:path>")
    def serve(path):
        if path != "" and os.path.exists(app.static_folder + "/" + path):
            return send_from_directory(app.static_folder, path)
        elif path == "/" or path == "":
            return send_from_directory(app.static_folder, "index.html")
        else:
            return redirect("/")

    app.register_blueprint(api, url_prefix="/api")

    return app
