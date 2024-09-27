# MANVSim Server
This document contains the most important information to start or continue developing the MANVSim server. Saying 'server'
this directory includes only python related code. Additional information about the component coupling is located
[here](../doc/server/README.md).

## Prerequisites
In order to run this server on your local system, you need to have Python3 and Pip3 installed and available in your path.

## Getting Started
You can start the server locally using the initial docker setup. However, if you want to start the server locally
make sure you have Flask available in your directory environment. Further, the server uses SQLAlchemy to integrate a
database. The docker setup has an integrated volume for a PostgreSQL DB. Local development allows an SQLite database
which can be migrated using the default project config. You need to perform the following commands:

```bash
flask --app main db migrate
flask --app main db upgrade
python .\dbsetup.py
```

The server can be run using:
```bash
flask --app main --debug run -p 5002
```

### Migrations
To keep your database up to date after updates to the [database model](models.py), you need to recreate a migration.
Migrations alter the currently applied database scheme to reflect a desired state. Performing the commands above should
integrate your update. Make sure to modify the [dbsetup](dbsetup.py) to ensure a successful setup.


## Working with test-data

CAUTION: By now (27.09.2024) the [test-data](execution/tests/entities/dummy_entities.py) have been historically changed due to evolving requirements.
The test-data is used by the implemented [unit and integration tests](execution/tests). However, they may be buggy regarding future implementations.
We as developer team advise you to recreate a runtime entity scenario. It may cause some tests to crash, but we welcome
any improvements.

CAUTION: Any test working with database entries are currently working on the local database. Therefore, changes in the
test may change your db setup for the local running server. We advise you to create a separate database for test-runs
to ensure test isolation.

Initially no test data are loaded into the memory. If you want to use sample data required for endpoint testing you can set a
flag to your environment `LOAD_TEST_DATA` or change the boolean flag [here](vars.py).
Additionally, the specific test-data can be modified. That means a patient containing a time-limited state-graph.
The timelimit of the state can also be configured [here](vars.py).
Loading test data creates two execution in memory containing the same content except the players' IDs. The details
are as follows:

| status  | ID | player IDs            |
|---------|----|-----------------------|
| Pending | 1  | - 123ABC<br/>- 456DEF |
| Running | 2  | - 987ZYX<br/>- 654WVU |

## Directories

| Directory           | Content                                                                                                                                                                                                                                                                    |
|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ``./administation`` | This directory contains all python files related to user and security management. It only provides endpoint to the web-api.                                                                                                                                                |
| ``./execution``     | This directory contains all python files related to the simulation game. That means the simulation game is managed along with the corresponding REST-API for the app communication. Additionally the component contains an wep-api interface to allow live administration. |
| ``./media``         | This directory contains all python files related to persisting and retrieving media files.                                                                                                                                                                                 |
| ``./scenario``      | This directory contains all python files related to editing a scenario using the web-api. This includes any other base-data used along the application.                                                                                                                    |

## Files
| File              | Content                                                                                               |
|-------------------|-------------------------------------------------------------------------------------------------------|
| ``./app.py``      | Contains a method to create the flask app along with flask configurations.                            |
| ``./app_config``  | Contains further configuration variables/classes.                                                     |
| ``./conftest.py`` | Defines the global test setup. Provides authentication methods required for passing the apps security |
| ``./dbsetup.py``  | Contains a script to set up the database with individual data.                                        |
| ``./models.py``   | Defines the database model, used in the db migration.                                                 |
| ``./vars.py``     | Contains global variables for the server.                                                             |
