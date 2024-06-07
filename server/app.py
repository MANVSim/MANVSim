import logging
import os
from flask import Blueprint, Flask, send_from_directory, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_wtf.csrf import CSRFProtect

db = SQLAlchemy()
csrf = CSRFProtect()

logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.DEBUG)


def create_app():
    """
    Create the app instance, register all URLs and the database to the app
    """
    # asynchronously import local packages
    import executions.api.register
    import web.api.register

    app = Flask(__name__, static_folder="../web/dist")
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
    app.config["SECRET_KEY"] = (
        "APP_DEBUG_DO_NOT_USE_IN_PROD_20556f99182444688d9bc48cc456e99031cd39c391accd9ea2e1ff1b500405358c999c50eafe"
        + "8c6d8fe61a148850e658374d42592f81e411e652fb3ee6839e76"
    )  # FIXME

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
            return (
                "API Endpoint not found. Please refactor your request or contact the admin",
                404,
            )
        elif path.startswith("web/"):
            return {"error": "Unknown endpoint"}, 404
        else:
            return redirect("/")

    app.register_blueprint(web.api.register.api, url_prefix="/web")
    app.register_blueprint(executions.api.register.api, url_prefix="/api")

    return app
