from flask import Blueprint, request
from flask_jwt_extended import jwt_required

from execution.utils import util

api = Blueprint("api-notification", __name__)


@api.get("/notifications")
@jwt_required()
def get_notification():
    try:
        execution, _ = util.get_execution_and_player()
        args = request.args
        next_id = int(args["next_id"])

        if len(execution.notifications) < next_id:
            return "Requested id larger than notifications available.", 418

        if len(execution.notifications) == next_id:
            return "", 204

        return {
            "notifications": execution.notifications[next_id:],
            "next_id": len(execution.notifications)
        }

    except KeyError:
        return "Invalid request-query detected.", 400

