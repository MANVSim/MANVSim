from flask import Blueprint
from flask_jwt_extended import create_access_token
from flask_login import login_user

import models
from utils.decorator import required, RequiredValueSource

web_api = Blueprint("web_api-login", __name__)


@web_api.post("/login")
@required("username", str, RequiredValueSource.FORM)
@required("password", str, RequiredValueSource.FORM)
def login(username: str, password: str):
    # Get user object from database
    user = models.WebUser.get_by_username(username)
    if user is None:
        return {
            "error": f"User with user name '{username}' does not exist"
        }, 401

    # Check password
    if not user.check_password(password):
        return {"error": "Incorrect password"}, 401

    login_user(user)
    return {
        "token": create_access_token(identity=user.role),
        "username": username
    }, 200
