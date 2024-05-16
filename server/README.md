# MANVSim Server

This component represents the server/backend part of MANVSim.

## Getting Started

Of course, you can run this server locally. We try to guide you through the process of getting started.

### Prerequisites

In order to run this server on your local system, you need to have Python3 and Pip3 installed and available in your path.

#### Optional

We provide a simple interface to our scripts via a `Makefile`. However, to use it you need `make` installed on your system (and also available in your path).

### Setup

To setup your local workspace, create the database and the admin user, simply run _one of the follwing_:

```bash
make
```

```bash
bash ./scripts/setup.sh
```

### Running It

Starting the server is as simple as setting up the workspace: Just use our run script:

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

### Frontend

To actually see anything when opening the default URL, you first need to build the frontend:

```bash
make build-frontend
```

If you want to actively develop the frontend, you need to run a different command:

```bash
make start-frontend
```

Note: To get the actual output delivered via the flask webserver, you need to run `make build-frontend`.
