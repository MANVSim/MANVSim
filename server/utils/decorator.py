from enum import StrEnum
from functools import wraps
from typing import Any, Callable

from cachetools.func import ttl_cache
from flask import abort, request
from flask_api import status
from flask_jwt_extended import get_jwt_identity, jwt_required
from werkzeug.exceptions import BadRequest

from models import WebUser
from vars import DB_CACHE_TTL


class RequiredValueSource(StrEnum):
    FORM = "form"
    ARGS = "query parameters"
    JSON = "json"


def required(arg: str, converter: Callable[[str], Any], source_enum: RequiredValueSource):
    """
    Decorator to ensure that the given parameter is part of the request. The following sources can be used:
    - `~flask.request.form`
    - `~flask.request.args`

    :param arg: The argument which has to be present in the form or the args
    :param converter: Converter function that should be used to convert the string value to the desired value. Should throw "ValueError" when conversion fails
    :param source_enum: Where the given argument should come from
    :raises ValueError: source_enum is of the wrong type
    :raises BadRequest: Either the parameter is missing or the given argument could not be converted
    :return: The return of the decorated function
    """

    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            match source_enum:
                case RequiredValueSource.FORM:
                    source = request.form
                case RequiredValueSource.JSON:
                    source = request.json
                    if not source:
                        raise BadRequest(
                            f"Missing parameter in {str(source_enum)}: {arg}")
                case RequiredValueSource.ARGS:
                    source = request.args
                case _:
                    raise ValueError(
                        f"Not an option for the @required decorator: {source_enum}")

            value = source.get(arg)

            if value is None:
                raise BadRequest(
                    f"Missing parameter in {str(source_enum)}: {arg}")

            try:
                value = converter(value)
            except ValueError:
                raise BadRequest(
                    f"{arg} could not be converted to {converter.__name__}")

            kwargs[arg] = value
            return f(*args, **kwargs)

        return wrapper

    return decorator


def admin_only(func: Callable):
    """
    Decorator for a flask endpoint that only allows access to logged in users with the web admin role.

    :param func: The function to wrap
    :return: Whatever the decorated function returns
    """

    @wraps(func)  # https://stackoverflow.com/a/64534085/11370741
    @jwt_required()
    def wrapper(*args, **kwargs):
        user_role = get_jwt_identity()
        try:
            user_role = WebUser.Role.from_string(user_role)
        except ValueError:
            abort(status.HTTP_401_UNAUTHORIZED)

        if user_role < WebUser.Role.WEB_ADMIN:
            abort(status.HTTP_403_FORBIDDEN)

        return func(*args, **kwargs)

    return wrapper


def role_required(required_role: WebUser.Role):
    """
    Decorator for a flask endpoint that only allows access to logged-in users with a specific role.

    NOTE: This decorator needs to be the outermost to ensure working properly!

    :param required_role: The role required to access the endpoint
    :return: A decorator that wraps the function
    """

    def decorator(func: Callable):
        @wraps(func)
        @jwt_required()
        def wrapper(*args, **kwargs):
            user_role = get_jwt_identity()
            try:
                user_role = WebUser.Role.from_string(user_role)
            except ValueError:
                abort(status.HTTP_401_UNAUTHORIZED)

            if user_role < required_role:
                abort(status.HTTP_403_FORBIDDEN)

            return func(*args, **kwargs)

        return wrapper

    return decorator


def cache(f: Callable):
    """
    Decorator that caches a single result for the time set in vars.py. Most
    useful for functions that access the database periodically and do not expect
    the content of the database to change.

    :param f: The function whose result should be cached
    :return: The decorated function
    """

    @wraps(f)
    @ttl_cache(maxsize=1, ttl=DB_CACHE_TTL)
    def wrapper(*args, **kwargs):
        return f(*args, **kwargs)

    return wrapper
