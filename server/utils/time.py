import time


def current_time_ms():
    """ Returns the current time in milliseconds since 1970. """
    return round(time.time() * 1000)


def current_time_s():
    """ Returns the current time in seconds since 1970. """
    return round(time.time())
