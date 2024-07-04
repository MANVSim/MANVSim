import logging
import os
# Docstring has to be below the variable
LOG_LEVEL = logging.DEBUG
ACQUIRE_TIMEOUT = 3
"""The timeout used to time out a locking-request"""
DB_CACHE_TTL = 10
"""
Used by the `@utils.db.cache` decorator to determine after how many seconds the
database should be queried again instead of returning a cached result
"""
# -- TESTING

LOAD_TEST_DATA = os.getenv('LOAD_TEST_DATA')
if not LOAD_TEST_DATA:
    LOAD_TEST_DATA = False  # If LOAD_TEST_DATA is not set, assign a default boolean value

# a patient will be assigned with a time dependent activity diagram
INCLUDE_TIMELIMIT = True

# configures the timelimit on a patient before the initial state is outdated.
# Negative values invalided a state immediately
PATIENT_TIMELIMIT = 10
