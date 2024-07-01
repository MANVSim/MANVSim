from flask import Blueprint
from flask_wtf.csrf import generate_csrf

from app_config import csrf

web_api = Blueprint("web_api-scenario", __name__)


@web_api.get("/csrf")
@csrf.exempt
def get_csrf():
    return {"csrf_token": generate_csrf()}
