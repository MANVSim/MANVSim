# MANVSim

MANVSim: **Sim**ulation eines [**Ma**ssen**an**falls **v**on **V**erletzten](https://de.wikipedia.org/wiki/Massenanfall_von_Verletzten).

Dieses Projekt ist das Ergebnis eines Bachelor- und Masterprojektes an der [CAU](https://www.uni-kiel.de).

### Project Structure

This application consists of a [Flask](https://flask.palletsprojects.com) Backend, a [React](https://react.dev/) web
admin frontend and a [Flutter](https://flutter.dev/) app which can be built for Android, iOS or web.  
Directory structure:

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