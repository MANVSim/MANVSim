import os
from flask import Flask, send_from_directory, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import CSRFProtect

db = SQLAlchemy()
csrf = CSRFProtect()


def create_app():
    """
    Create the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    from executions.api import register

    app = Flask(__name__, static_folder="../web/dist")
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
        elif path.startswith("/api"):
            return "API Endpoint not found. Please refactor your request or contact the admin", 404
        else:
            return redirect("/")

    app.register_blueprint(register.api, url_prefix="/api")

    return app
