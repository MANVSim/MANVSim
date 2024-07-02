import json
import logging
import os

from flask import Flask, send_from_directory, redirect, make_response, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_sqlalchemy import SQLAlchemy
from flask_wtf.csrf import CSRFProtect, CSRFError
from werkzeug.exceptions import HTTPException

logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.DEBUG)


def create_app(csrf: CSRFProtect, db: SQLAlchemy):
    """
    Create the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    import models  # noqa: F401
    import execution.web_api.setup
    import scenario.web_api.setup
    import administration.web_api.setup
    import execution.api.setup

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

    # -- Endpoint connection
    execution.web_api.setup.setup(app)
    scenario.web_api.setup.setup(app)
    administration.web_api.setup.setup(app)
    execution.api.setup.setup(app)

    CORS(app, resources={r"/*": {"origins": "*"}})

    # -- FE Routes
    @app.route("/", defaults={"path": ""})
    @app.route("/<path:path>")
    def serve(path):
        """ Registers paths required for serving frontend. """
        if path != "" and os.path.exists(app.static_folder + "/" + path):  # type: ignore
            return send_from_directory(app.static_folder, path)  # type: ignore
        elif path == "/" or path == "":
            return send_from_directory(app.static_folder, "index.html")  # type: ignore
        elif path.startswith("/api"):
            return (
                "API Endpoint not found. Please refactor your request or contact the admin",
                404,
            )
        elif path.startswith("web/"):
            return {"error": "Unknown endpoint"}, 404
        else:
            return redirect("/")

    # -- ERROR Handling
    @app.errorhandler(HTTPException)
    def http_exception_handler(e: HTTPException):
        """ Return JSON instead of HTML for HTTP errors. """
        # start with the correct headers and status code from the error
        response = make_response(e.get_response())
        # replace the body with JSON
        response.data = json.dumps({
            "error": e.description,
        })
        response.content_type = "application/json"
        return response

    @app.errorhandler(CSRFError)
    def handle_csrf_error(error: CSRFError):
        """ Defines a specific handling for CSRF Errors"""
        status = error.response or 400
        return make_response(({"error": error.description}, status))

    def handle_error(e):
        return jsonify(error=str(e)), e.code

    for code in range(400, 600):
        # Register all client-/server error to be handled as json response.
        try:
            app.register_error_handler(code, handle_error)
        except ValueError:
            continue  # continue if code is not a valid HTTP status code.

    return app
