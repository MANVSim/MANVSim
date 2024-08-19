from flask import Blueprint

import models
from models import WebUser
from utils.decorator import role_required

web_api = Blueprint("web_api-scenario", __name__)


@web_api.get("/templates")
@role_required(WebUser.Role.READ_ONLY)
def get_templates():
    return [
        {
            "id": scenario.id,
            "name": scenario.name,
            "executions": [
                {"id": execution.id, "name": execution.name}
                for execution in scenario.executions
            ]
        }
        for scenario in models.Scenario.query
    ]
