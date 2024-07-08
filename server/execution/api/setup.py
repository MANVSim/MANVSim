from flask import Flask, request
from flask_jwt_extended import jwt_required
from werkzeug.exceptions import BadRequestKeyError

from execution.api import lobby, notification, patient, location, action
from execution.entities.execution import Execution
from execution.utils import util


def setup(app: Flask):
    """ Connects each implemented endpoint to flask environment. """

    @patient.api.before_request
    @location.api.before_request
    @action.api.before_request
    def return_empty_if_not_running():
        """ Blocks all run-request on an execution which is still in status pending. """
        @jwt_required()
        def check_for_exec_status():
            try:
                exc, _ = util.get_execution_and_player()
                if exc.status != Execution.Status.RUNNING:
                    return "", 204

            except BadRequestKeyError:
                return f"Incorrect JWT detected.", 400
            except KeyError:
                return (
                    f"Invalid Execution ID sent. Unable to resolve running instance",
                    400,
                )

        if "/api/run" in request.path and request.method != "OPTIONS":
            return check_for_exec_status()

    app.register_blueprint(lobby.api, url_prefix="/api")
    app.register_blueprint(notification.api, url_prefix="/api")
    app.register_blueprint(patient.api, url_prefix="/api/run")
    app.register_blueprint(location.api, url_prefix="/api/run")
    app.register_blueprint(action.api, url_prefix="/api/run")
