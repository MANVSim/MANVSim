import logging
import os

from flask import Flask, send_from_directory, redirect, request
from flask_jwt_extended import JWTManager, jwt_required
from flask_sqlalchemy import SQLAlchemy
from flask_wtf.csrf import CSRFProtect
from flask_cors import CORS
from werkzeug.exceptions import BadRequestKeyError

from execution.utils import util
from execution.entities.execution import Execution
from media import media

logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.DEBUG)


def create_app(csrf: CSRFProtect, db: SQLAlchemy):
    """
    Create the app instance, register all URLs and the database to the app
    """
    import models  # noqa: F401

    # asynchronously import local packages
    import web.setup
    import execution.web.setup
    from execution.api import lobby, location, patient, action, notification

    app = Flask(__name__, static_folder="../web/dist")
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
    app.config["SECRET_KEY"] = (
        "APP_DEBUG_DO_NOT_USE_IN_PROD_20556f99182444688d9bc48cc456e99031cd39c391accd9ea2e1ff1b500405358c999c50eafe"
        + "8c6d8fe61a148850e658374d42592f81e411e652fb3ee6839e76"
    )  # FIXME
    app.config["JWT_SECRET_KEY"] = "!ichsolltenichtinPROD!"

    db.init_app(app)
    csrf.init_app(app)
    jwt = JWTManager(app)
    web.setup(app)      # FIXME deprecated package
    execution.web.setup.setup(app)
    CORS(app, resources={r"/*": {"origins": "*"}})

    # define run request blocker
    @app.before_request
    def return_hold_if_not_running():
        @jwt_required()
        def check_for_exec_status():
            try:
                execution, _ = util.get_execution_and_player()
                if execution.status != Execution.Status.RUNNING:
                    return "No running execution detected", 204

            except BadRequestKeyError:
                return f"Incorrect JWT detected.", 400
            except KeyError:
                return (
                    f"Invalid Execution ID sent. Unable to resolve running instance",
                    400,
                )

        if "/api/run" in request.path:
            return check_for_exec_status()

    # register paths required for serving frontend
    @app.route("/", defaults={"path": ""})
    @app.route("/<path:path>")
    def serve(path):
        if path != "" and os.path.exists(app.static_folder + "/" + path):
            return send_from_directory(app.static_folder, path)
        elif path == "/" or path == "":
            return send_from_directory(app.static_folder, "index.html")
        elif path.startswith("/api"):
            return (
                "API Endpoint not found. Please refactor your request or contact the admin",
                404,
            )
        elif path.startswith("web/"):
            return {"error": "Unknown endpoint"}, 404
        else:
            return redirect("/")

    # Media-API
    media.setup(app)
    app.register_blueprint(media.api, url_prefix="/media")
    # Simulation-API
    app.register_blueprint(lobby.api, url_prefix="/api")
    app.register_blueprint(notification.api, url_prefix="/api")
    app.register_blueprint(patient.api, url_prefix="/api/run")
    app.register_blueprint(location.api, url_prefix="/api/run")
    app.register_blueprint(action.api, url_prefix="/api/run")

    return app
