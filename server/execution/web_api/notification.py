from datetime import datetime

from flask import Blueprint, request

from execution import run
from models import WebUser
from utils.decorator import role_required

web_api = Blueprint("web_api-notification", __name__)


@web_api.post("/notifications/post")
@role_required(WebUser.Role.GAME_MASTER)
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
        current_time = datetime.now()
        formatted_time = current_time.strftime("%d.%m.%Y %H.%M")
        execution.notifications.append(
            {
                "timestamp": formatted_time,
                "text": notification
            }
        )
        return "Post successful", 200
    except KeyError:
        return {
            "error": "Unable to post notification. Invalid parameter detected."}, 400
