from enum import StrEnum
from functools import wraps
from typing import Callable

from flask import abort, request
from flask_api import status
from flask_jwt_extended import get_jwt_identity, jwt_required
from werkzeug.exceptions import BadRequest, NotFound

from execution.entities.execution import Execution
from execution.run import active_executions


class RequiredValueSource(StrEnum):
    FORM = "form"
    ARGS = "query parameters"


def required(arg: str, converter: Callable, source_enum: RequiredValueSource):
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


def admin_only(func: Callable):
    """
    Decorator for a flask endpoint that only allows access to logged in users with the admin role

    :param func: The function to wrap
    :return: Whatever the decorated function returns
    """
    @wraps(func)  # https://stackoverflow.com/a/64534085/11370741
    @jwt_required()
    def wrapper(*args, **kwargs):
        identity = get_jwt_identity()
        if identity != "admin":
            abort(status.HTTP_401_UNAUTHORIZED)
        return func(*args, **kwargs)

    return wrapper


def try_get_execution(id: int) -> Execution:
    """
    Tries to return the execution from the runtime. If the execution does not exist a 404 Error is raised.

    :param id: ID of the execution
    :return: The execution object
    :raises NotFound: Error when execution does not exist
    """
    try:
        execution = active_executions[id]
    except KeyError:
        raise NotFound(f"Execution with id {id} does not exist")

    return execution
