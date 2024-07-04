# For some reason the docstring has to be below the variable

ACQUIRE_TIMEOUT = 3
"""The timeout used to time out a locking-request"""
DB_CACHE_TTL = 10
"""
Used by the `@utils.db.cache` decorator to determine after how many seconds the
database should be queried again instead of returning a cached result
"""
