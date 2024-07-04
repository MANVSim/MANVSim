from functools import wraps
from typing import Callable
import vars
from cachetools.func import ttl_cache


def cache(f: Callable):
    """
    Decorator that caches a single result for the time set in vars.py. Most
    useful for functions that access the database periodically and do not expect
    the content of the database to change.

    :param f: The function whose result should be cached
    :return: The decorated function
    """
    @wraps(f)
    @ttl_cache(maxsize=1, ttl=vars.DB_CACHE_TTL)
    def wrapper(*args, **kwargs):
        return f(*args, **kwargs)
    return wrapper
