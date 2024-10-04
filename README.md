# MANVSim

MANVSim: **Sim**ulation eines [**M**assen**an**falls von **V**erletzten](https://de.wikipedia.org/wiki/Massenanfall_von_Verletzten) (Simulation of
a [mass casualty incident](https://en.wikipedia.org/wiki/Mass_casualty_incident))

This project is the result of a joint Bachelor's and Master's project at [CAU Kiel](https://www.uni-kiel.de).

The aim of this project is to aid and enhance german paramedic training for mass casualty incidents (MCIs) by providing
playable simulations of configurable MCI scenarios with realistic patient simulations and interactions via a mobile app.

### Project Structure

This application consists of a Python [Flask](https://flask.palletsprojects.com) Backend, a [React](https://react.dev/)
web admin frontend and a [Flutter](https://flutter.dev/) app which can be built for Android, iOS or web.

### Directory Structure

```
MANVSim         # Project root
├── app         # Flutter app
├── config      # Config files
├── doc         # Documentation
├── info        # General info and meeting protocols
├── server      # Flask backend
└── web         # React web admin frontend
```

This project is managed on GitHub:  
**<https://github.com/MANVSim/MANVSim>**

### TLS

To ensure the app functions properly, TLS is required.
You need to provide a certificate named `fullchain.pem` and a key named `privkey.pem`,
both located in the `certs` directory.

If you don’t already have a certificate for your local machine,
you can create a self-signed certificate for development purposes by running the following script:

```bash
./certs/generate_local_cert.sh
```

This script will generate a self-signed certificate and place it in the `certs` directory.
When using this certificate, be sure to add it to your trusted certificates on your local machine.
Do not use this certificate in production environments and avoid checking the private key into any public repository.

### Start Application Locally

To start the current version of the application after ensuring the required TLS certificate is in place, run:

```bash
docker compose up
```

This will start the server and admin web frontend on  
**<http://localhost:5002>**   
and the web version of the app (with the android app apk downloadable) on  
**<http://localhost:5001>**

To skip the android app build use:

```bash
docker compose -f docker-compose.yaml -f compose-dev.yaml up
```

The docker environment uses the volume `db-manvsim` to persist data.

For specifics or alternatives to run the services see the `README.md` of the subprojects.

## Software Components

MANVSim comprises three software components: A Flutter/Dart frontend application called 'app', a Flask/Python server, 
and a React/TypeScript web frontend for the sever referenced as 'web'.

### App

TODO

### Server

For additional information on how to start and develop the server component or detailed documentation look [here](server/README.md).

### Web

TODO