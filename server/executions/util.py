from flask_jwt_extended import get_jwt


def get_param_from_jwt(param):
    claims = get_jwt()
    return claims[param]