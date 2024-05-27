import logging
import os
from flask import Flask, send_from_directory, redirect, request
from flask_jwt_extended import JWTManager
from flask_sqlalchemy import SQLAlchemy
from flask_wtf.csrf import CSRFProtect
from werkzeug.exceptions import BadRequestKeyError

from executions import run
from executions.entities.execution import Execution

db = SQLAlchemy()
csrf = CSRFProtect()

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)


def create_app():
    """
    Create the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    from executions.api import register, location

    app = Flask(__name__, static_folder="../web/dist")
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
    app.config["SECRET_KEY"] = (
        "APP_DEBUG_DO_NOT_USE_IN_PROD_20556f99182444688d9bc48cc456e99031cd39c391accd9ea2e1ff1b500405358c999c50eafe" +
        "8c6d8fe61a148850e658374d42592f81e411e652fb3ee6839e76"
    )  # FIXME
    app.config["JWT_SECRET_KEY"] = "!ichsolltenichtinPROD!"

    db.init_app(app)
    csrf.init_app(app)
    jwt = JWTManager(app)

    # define run request blocker
    @app.before_request
    def return_hold_if_not_running():
        if "/api/run" in request.path:
            logging.info("check api-run")
            try:
                exec_id = request.args["exec_id"]
                execution = run.exec_dict[exec_id]
                if execution.status != Execution.Status.RUNNING:
                    return f"Execution {exec_id}:{execution.scenario.name} is not running", 404

            except BadRequestKeyError:
                return f" No request parameter 'exec_id' found.", 400
            except KeyError:
                return f"Invalid Execution ID sent. Unable to resolve running instance", 400

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
    app.register_blueprint(location.api, url_prefix="/api/run")

    return app

