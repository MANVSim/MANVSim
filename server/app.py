import json
import logging
import os
import secrets

from flask import Flask, send_from_directory, redirect, make_response, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_sqlalchemy import SQLAlchemy
from flask_wtf.csrf import CSRFProtect, CSRFError
from werkzeug.exceptions import HTTPException

from vars import LOG_LEVEL

logging.basicConfig(format="%(levelname)s:%(message)s", level=LOG_LEVEL)


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
    import media.media_api

    app = Flask(__name__, static_folder="../web/dist")
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
    app.config["SECRET_KEY"] = os.getenv('SECRET_KEY', 'default-not-so-secret-secret-key')
    app.config["JWT_SECRET_KEY"] = os.getenv('SECRET_KEY', 'default-not-so-secret-secret-key')

    db.init_app(app)
    csrf.init_app(app)
    JWTManager(app)

    # -- Endpoint connection
    execution.web_api.setup.setup(app)
    scenario.web_api.setup.setup(app)
    administration.web_api.setup.setup(app)
    execution.api.setup.setup(app)
    media.media_api.setup(app)

    CORS(app, resources={r"/*": {"origins": "*"}})

    # -- FE Routes
    @app.route("/", defaults={"path": ""})
    @app.route("/<path:path>")
    def serve(path):
        """ Registers paths required for serving frontend. """
        if not app.static_folder:
            app.static_folder = ""

        if path != "" and os.path.exists(app.static_folder + "/" + path):
            return send_from_directory(app.static_folder, path)
        elif path == "/" or path == "":
            return send_from_directory(app.static_folder, "index.html")
        elif path.startswith("/api"):
            return (
                "API Endpoint not found. Please refactor your request or "
                "contact the admin",
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
