from flask import Blueprint, request

from execution import run
from models import WebUser
from utils.decorator import role_required

web_api = Blueprint("web_api-notification", __name__)


@role_required(WebUser.Role.GAME_MASTER)
@web_api.post("/notifications/post")
def add_notification_to_execution():
    """
    Endpoint for adding a notification to an execution via the execution id.
    Each parameter is set as form parameter.
    Returns OK for successful requests or BAD_REQUEST in case of invalid parameters
    """
    form = request.form

    try:
        exec_id = int(form["exec_id"])
        notification = form["notification"]
        execution = run.active_executions[exec_id]

        execution.notifications.append(notification)
        return "Post successful", 200
    except KeyError:
        return {"error": "Unable to post notification. Invalid parameter detected."}, 400
