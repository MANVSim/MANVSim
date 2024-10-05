# Deployment

This document describes the deployment of the MANVSim project with Docker Compose. A [quickstart](#quickstart) guide
for fast deployment is provided at the end of the document.

## Contents

<!-- TOC -->
* [Deployment](#deployment)
  * [Contents](#contents)
  * [Overview](#overview)
  * [Prerequisite](#prerequisite)
  * [Services](#services)
    * [app](#app)
    * [server](#server)
    * [web](#web)
    * [postgres](#postgres)
    * [nginx](#nginx)
  * [Service dependencies](#service-dependencies)
  * [Configuration](#configuration)
    * [server](#server-1)
    * [web](#web-1)
    * [app](#app-1)
    * [nginx](#nginx-1)
    * [postgres](#postgres-1)
  * [TLS](#tls)
    * [Localhost and development](#localhost-and-development)
    * [Production](#production)
  * [Quickstart](#quickstart)
    * [Localhost deployment](#localhost-deployment)
    * [Production deployment](#production-deployment)
<!-- TOC -->

## Overview

The whole project can be deployed with Docker Compose using the [docker-compose.yaml](../../docker-compose.yaml) file.
The following diagram shows the deployment structure of the project in general:

![](deployment_diagram.png)

## Prerequisite

To deploy the project with Docker Compose you need the following to be installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

You also need to have an internet connection during build to download the necessary images and packages.

## Services

### app

The app is a Flutter application that is used by the players to participate in the simulation. It is located in the
`app`
directory. For more general information on the app, see the [app README](../app/README.md).

|               | **Description**                               |
|---------------|-----------------------------------------------|
| **Port**      | `5001`                                        |
| **Image**     | Build from [Dockerfile](../../app/Dockerfile) |
| **Webserver** | [nginx](https://www.nginx.com/)               |

The app is built using the [Dockerfile](../../app/Dockerfile) in the `app` directory.
It uses docker multi-stage build. The web and the android app are built in the same image.
The web app is then served by nginx. The android app can be downloaded from the web apps login page.

### server

The server is a Flask application that provides the API for web and app. It is located in the `server`
directory. For more general information on the server, see the [server README](../server/README.md).

|               | **Description**                                  |
|---------------|--------------------------------------------------|
| **Port**      | `5002`                                           |
| **Image**     | Build from [Dockerfile](../../server/Dockerfile) |
| **Webserver** | [Gunicorn](https://gunicorn.org/)                |

The server is built using the [Dockerfile](../../server/Dockerfile) in the `server` directory.
It sets up the flask application with a production-ready environment using Docker multi-stage build.
The Production stage uses guincorn as the WSGI server to serve the application.
Gunicorn is set up with the startup script [entrypoint.sh](../../server/scripts/entrypoint.sh) in
the servers `scripts` directory. For configuration see the config section.

### web

The web frontend is a React application that provides the admin interface for the server. It is located in the `web`
directory. For more general information on the web frontend, see the [web README](../web/README.md).

|               | **Description**                               |
|---------------|-----------------------------------------------|
| **Port**      | `5003`                                        |
| **Image**     | Build from [Dockerfile](../../web/Dockerfile) |
| **Webserver** | [nginx](https://www.nginx.com/)               |

The web frontend is built using the [Dockerfile](../../web/Dockerfile) in the `web` directory.
It sets up the React application with a production-ready environment using Docker multi-stage build.
The Production stage uses nginx as the webserver to serve the application.
Nginx is configured to serve the static files. It uses the [nginx.conf](../../web/nginx.conf) in the web directory.
For configuration details see the config section.

### postgres

The database is a PostgreSQL database that is used by the server for persistence. The service is built from the
official PostgreSQL image. The database is initialized with the sql files from the `config/postgres/sql` directory (The
files are executed in alphabetical order). The database is persisted in a volume named `db-manvsim`.

|               | **Description**                                 |
|---------------|-------------------------------------------------|
| **Port**      | `5432`                                          |
| **Image**     | [PostgreSQL](https://hub.docker.com/_/postgres) |
| **Webserver** | None                                            |

### nginx

The nginx service is used as a reverse proxy to route the requests to the correct service. It is built from the official
nginx image. The configuration is located in the `config/nginx` directory.

|               | **Description**                 |
|---------------|---------------------------------|
| **Port**      | `80` and `443`                  |
| **Image**     | [nginx](https://www.nginx.com/) |
| **Webserver** | [nginx](https://www.nginx.com/) |

This service also provides the TLS termination for the application. The certificates are located in the `config/certs`
directory. It also serves the static [landing page](../../index.html) for the project.

## Service dependencies

The services are dependent on each other. The following diagram shows the dependencies between the services:

<img src="dependency_diagram.png" alt="Dependency Diagram" style="max-height: 400px;">

Docker compose will start all services in the correct order.
If you want to start the services individually, you have to start them in the following order:

1. postgres
2. server
3. web and app
4. nginx

Because the nginx service is the only service that is exposed to the host and it depends on all other services,
it is not reasonable to start a single service (e.g for development). If you want to do this anyway, you have to adapt
the service configuration in the [docker-compose.yaml](../../docker-compose.yaml) file (e.g. add port mappings and
remove dependencies).

## Configuration

### server

The server configuration environment variables can be configured in the server's configuration file
[.env](../../config/server/.env).

| Variable         | Description                                                                                                                                                                               | default                           |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| SECRET_KEY       | secret hmac key used for the servers jwt token signing                                                                                                                                    | secret_key_replace_for_production |
| SERVER_THREADS   | The number of threads gunicorn should use for handling requests. The [gunicorn documentation](https://docs.gunicorn.org/en/stable/settings.html#threads) recommends 2-4 threads per core. | 16                                |
| SERVER_LOG_LEVEL | Log level of the server                                                                                                                                                                   | warn                              |

If you want to further configure gunicorn or the server you can have a look at the
[entrypoint.sh](../../server/scripts/entrypoint.sh) startup script.

The server also needs a postgres configuration. This is described in the postgres section of this chapter.

### web

For the web frontend, there is no separate configuration file. The path to the server API has to be set during build in
the [Dockerfile](../../web/Dockerfile) with the `VITE_API_URL` environment variable (dfault value is
`https://localhost/web/`).

The nginx configuration is located in the [nginx.conf](../../web/nginx.conf) file for further configuration.

### app

The app configuration can be set in the [config.json](../../config/app/config.json) file in the `config/app` directory.
The following configuration options are available:

| Variable              | Description                                                                                  | default               |
|-----------------------|----------------------------------------------------------------------------------------------|-----------------------|
| apiUrl                | The default API URL. Can be overridden by the user or through an QR code on the login screen | https://localhost/api |
| showMap               | Show the map in the app.                                                                     | true                  |
| showPatientList       | Show the patient list in the app.                                                            | true                  |
| showLocationList      | Show the location list in the app.                                                           | true                  |
| waitScreenIsSkippable | Allow the user to skip the wait screen. Should be only allowed for development               | false                 |

There is the same configuration file [config.json](../../app/assets/config/config.json) in the app's assets directory
for local development only. This file is overwritten inside the Docker image with the one from the `config/app`

The nginx configuration is located in the [nginx.conf](../../app/nginx.conf) file for further configuration.

### nginx

The nginx configuration is located in the [nginx.conf](../../config/nginx/component_mapping.conf) file in the
`config/nginx`
directory. The configuration is used to map the requests to the correct service as described in the service section.

The certificates and the corresponding key for the TLS termination have to be placed in the `config/certs` directory
and named `privkey.pem` and `fullchain.pem` as described in the TLS section.

### postgres

The postgres configuration is set in the [.env](../../config/postgres/.env) file in the `config/postgres` directory.
The configuration is used to set up the database and the user for the server:

| Variable          | Description                                                                                   | default                                                                 |
|-------------------|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| POSTGRES_USER     | The username for the database user                                                            | admin                                                                   |
| POSTGRES_PASSWORD | The password for the database user                                                            | use_secure_password_for_production                                      |
| DATABASE_URI      | The URI for the database connection. The URI is used by the server to connect to the database | 'postgresql://\${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/manv |


## TLS

The TLS termination is done by the nginx service. The certificates and the corresponding key have to be placed in the
`config/certs` directory and named `privkey.pem` and `fullchain.pem`. The certificates are used by the nginx service only.
All other services communicate with each other over the internal docker network and do not need TLS.

### Localhost and development

For development, you can use self-signed certificates. You can generate them with the following command:

```bash
./config/certs/generate_local_cert.sh
```

The script will generate a self-signed certificate and key and place them in the `config/certs` directory.
These certificates are only for development and should not be used in production. They are not trusted by browsers
so you need to add them to your local trust store. Make sure to not check them into any version control system afterwards.

### Production

For production, you should use a trusted certificate. You can get a certificate from a certificate authority (CA).
For example, you can use [Let's Encrypt](https://letsencrypt.org/) with [certbot](https://certbot.eff.org/) to
get a free certificate:
    
```bash
certbot certonly --standalone -d yourdomain.com
```

This command will generate a certificate and key and place them in the `/etc/letsencrypt/live/yourdomain.com` directory
and you cab copy them to the `config/certs` directory:

```bash
cp /etc/letsencrypt/live/yourdomain.com/privkey.pem config/certs/privkey.pem
cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem config/certs/fullchain.pem
```

## Quickstart

Before you start the deployment, make sure the [prerequisites](#prerequisite) are installed correctly.

Then you can choose between a [localhost deployment](#localhost-deployment) (for development or local testing) and a 
[production deployment](#production-deployment).

### Localhost deployment
You don't need to change any configuration for a deployment on localhost.
Just run the docker-compose command in the root directory of the project:

```bash
docker-compose up -d --build
```

The landing page is than available at [https://localhost](https://localhost).

### Production deployment
For a production deployment, where the application is available under a domain, you have to adapt the domain 
instead of localhost in the following configuration files:

- [web Dockerfile](../../web/Dockerfile) (VITE_API_URL)
- [app config.json](../../config/app/config.json) (apiUrl -> optional but highly recommended)

After that, the same steps as for the localhost deployment can be followed.








