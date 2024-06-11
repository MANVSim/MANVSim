# MANVSim Server

This component represents the server/backend part of MANVSim.

## Getting Started

Of course, you can run this server locally. We try to guide you through the process of getting started.

### Prerequisites

In order to run this server on your local system, you need to have Python3 and Pip3 installed and available in your path.

#### Optional

We provide a simple interface to our scripts via a `Makefile`. However, to use it you need `make` installed on your system (and also available in your path).

### Setup

To setup your local workspace, create the database and web frontend, simply run _one of the follwing_:

```bash
make
```

```bash
bash ./scripts/setup.sh
```

### Running It

Starting the server is as simple as setting up the workspace. Just use our run script:

```bash
make run
```

```bash
bash ./scripts/start-server.sh
```

### Cleanup

If you ever come across a situation where you completely messed up your workspace and feel the urge to wipe everything and start from scratch, we've got you covered!

```bash
make clean
```

```bash
bash ./scripts/cleanup.sh
```

### Migrations

To keep your database up to date after commits, we provide utilities for performing migrations. Migrations alter the currently applied database scheme to reflect a desired state.

To apply all current migrations, simply run on of the following:

```bash
make migrate
```

```bash
bash ./scripts/perform-migration.sh
```

After you change any of the used models within the application, you need to create a new migration **and apply it afterwards**:

```bash
make migration
```

```bash
bash ./scripts/create-migration.sh
```

### Architecture
 As proposed in our [Architecture Diagramm](../doc/server/Architecture%20Backend%20Components.svg) the directory is structured as follows:
 - ```administration``` (grey) contains everything related to administrate the WEB API. It does not interfere with the game creation or instance management.
 - ``executions`` (green) contains everything related to our running game instances. Loading from DB, changing a game status, start/stop an execution etc... It contains endpoint to both mobile [API](executions/api) and [WEB API](executions/web).
 - ``scenarios`` (red) contains everything related to create and pre-save a game instance. Its endpoints are provided for the WEB API only. Its workflow directed to persist every data in the database.

![ArchitectureDiagram](../doc/server/Architecture%20Backend%20Components.svg)