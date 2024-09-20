from datetime import datetime

import pytz
from flask import Blueprint, request

from execution import run

web_api = Blueprint("web_api-notification", __name__)


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
        utc_time = datetime.now()
        berlin_time = utc_time.astimezone(pytz.timezone('Europe/Berlin'))
        formatted_time = berlin_time.strftime("%d.%m.%Y %H:%M")

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
