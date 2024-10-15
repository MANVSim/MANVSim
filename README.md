# MANVSim

MANVSim: **Sim**ulation eines [**M**assen**an**falls von **V**erletzten](https://de.wikipedia.org/wiki/Massenanfall_von_Verletzten) (Simulation of
a [Mass Casualty Incident](https://en.wikipedia.org/wiki/Mass_casualty_incident))

This project is the result of a joint Bachelor's and Master's project at [CAU Kiel](https://www.uni-kiel.de).

The aim of this project is to aid and enhance german paramedic training for mass casualty incidents (MCIs) by providing
playable simulations of configurable MCI scenarios with realistic patient simulations and interactions via a mobile app.

### Project Structure

This application consists of a Python [Flask](https://flask.palletsprojects.com) backend called 'server', a [React](https://react.dev/)
web admin frontend for the server referenced as 'web' and a [Flutter](https://flutter.dev/) app which can be built for Android, iOS or web.

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


## Quickstart

To quickly deploy the MANVSim project, follow the instructions in the
[deployment documentation](doc/deployment/README.md#quickstart).



## Software Components

Additional information on the individual MANVSim components is linked here:

### App

For additional information on how to start and develop the app component or detailed documentation look [here](doc/app/README.md).

### Server

For additional information on how to start and develop the server component or detailed documentation look [here](server/README.md).

### Web

For additional information on how to start and develop the web component or detailed documentation look [here](web/README.md).
