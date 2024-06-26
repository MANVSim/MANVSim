from enum import StrEnum
from functools import wraps
from typing import Callable

from flask import abort, request
from flask_api import status
from flask_jwt_extended import get_jwt_identity, jwt_required
from werkzeug.exceptions import BadRequest, NotFound

from execution.run import active_executions


class RequiredValueSource(StrEnum):
    FORM = "form"
    ARGS = "query parameters"


def required(arg: str, converter: Callable, source_enum: RequiredValueSource):
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            if source_enum == RequiredValueSource.FORM:
                source = request.form
            elif source_enum == RequiredValueSource.ARGS:
                source = request.args
            else:
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


def admin_only(func):
    @wraps(func)  # https://stackoverflow.com/a/64534085/11370741
    @jwt_required()
    def wrapper(*args, **kwargs):
        identity = get_jwt_identity()
        if identity != "admin":
            abort(status.HTTP_401_UNAUTHORIZED)
        return func(*args, **kwargs)

    return wrapper


def try_get_execution(id: int):
    try:
        execution = active_executions[id]
    except KeyError:
        raise NotFound(f"Execution with id {id} does not exist")

    return execution
