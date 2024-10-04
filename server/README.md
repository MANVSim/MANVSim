# MANVSim Server

This document contains the most important information to start or continue developing the MANVSim server. The `server`
directory includes only Python-related code. Additional information and documentation about the system's architecture
and design decisions for individual components is located [here](../doc/server/README.md).

The documentation for starting and developing the servers React web frontend can be found in a separate document [here](../web/README.md).

## Prerequisites

In order to run this server on your local system, you need to have Python 3.12 or newer and `pip` installed and
available
in your path.

## Getting Started

You can start the server locally using the initial Docker setup. However, if you want to start the server without
starting the React-frontend or Flutter-app at the same time, e.g., for development, it is recommended to use
[Pipenv](https://pypi.org/project/pipenv/): `pip install pipenv`

In the `server` directory run:

```bash
pipenv install
```

The docker setup has an integrated volume for a PostgreSQL database. For local development a lightweight SQLite database
is integrated into the application, which can be set up with the following commands:

```bash
pipenv run flask --app main db init
pipenv run flask --app main db upgrade
pipenv run python3 dbsetup.py
```

After setting up the database successfully, the server can be started using:

```bash
pipenv run flask --app main --debug run -p 5002
```

The server is now listening in debug mode for requests on port 5002.

If you additionally want to start the servers React web frontend, look at the [web components documentation](../web/README.md).

**Note:** For use in a production environments it is highly recommended to use the provided Docker setup!

### Database: Migrations

To keep your database up to date after applying changes to the [database model](models.py), you need to create a new
migration. Migrations alter the currently applied database scheme to reflect a new desired state. Performing the
following commands should integrate your performed changes:

```bash
pipenv run flask --app main db migrate
pipenv run flask --app main db upgrade
```

**Note:** Make sure to modify the [dbsetup](dbsetup.py) script if needed after changing the models to ensure a
successful setup.

### Database: Reset

If you run into an inconsistent or broken database state and want to reset the servers state, delete the
`server/instance`
directory and all contents of it:

```bash
rm -rf instance
```

Then run the three database initialization commands from above to return to a consistent
starting point.

## Directories/Components

| Directory        | Content                                                                                                                                                                                                                                                                                                                                       |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `administation/` | Contains all python files related to user and security management. It currently only provides endpoints to the web-api.                                                                                                                                                                                                                       |
| `execution/`     | Contains all python files related to the simulation state. The simulation is loaded and managed here along with the definition of the corresponding entities. Additionally, the REST-API for the app communication is implemented here. Further, this component contains an wep-api interface to allow live administration of the simulation. |
| `media/`         | Contains all files related to persisting and retrieving media files including the media data itself.                                                                                                                                                                                                                                          |
| `scenario/`      | Contains all python files related to editing a scenario using the web-api. This includes any other base-data used along the application.                                                                                                                                                                                                      |

## Files

| File          | Content                                                                                               |
|---------------|-------------------------------------------------------------------------------------------------------|
| `app.py`      | Contains a method to create the flask app along with flask configurations.                            |
| `app_config`  | Contains further configuration variables/classes.                                                     |
| `conftest.py` | Defines the global test setup. Provides authentication methods required for passing the apps security |
| `dbsetup.py`  | Contains a script to set up the database with individual data.                                        |
| `models.py`   | Defines the database model, used in the db migration.                                                 |
| `vars.py`     | Contains global variables for the server.                                                             |
| `Pipfile`     | Specifies all dependencies and version numbers.                                                       |

## Working with Test Data

**CAUTION:** By now (27.09.2024) the [test data](execution/tests/entities/dummy_entities.py) has been historically changed
due to evolving requirements.
The test data is used by the implemented [unit and integration tests](execution/tests). However, they may be buggy
regarding future implementations.
We advise you to create a new runtime entity scenario if you plan to extend the simulation runtime logic. It may cause
some tests to break, as they are specifically designed for the current (outdated/simplistic) test scenario.

By default, no test data is loaded into the memory. If you want to use sample data required for endpoint testing you can
set a flag to your environment `LOAD_TEST_DATA` or change the boolean flag [here](vars.py).
Additionally, specific test data can be configured further. This means, for a patient containing a time-limited
state-graph,
the time limit of the state can be set [here](vars.py) for the current run.

Loading test data creates two executions in memory, containing the same content except the player IDs (TANs). The
details
are as follows:

| Status  | ID | Player TANs        |
|---------|----|--------------------|
| Pending | 1  | `123ABC`, `456DEF` |
| Running | 2  | `987ZYX`, `654WVU` |
