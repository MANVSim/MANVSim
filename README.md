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

### Start Application Locally

To start a development version of the application you may run:

```bash
docker compose up
```

This will start the server and admin web frontend on  
**<http://localhost:5000>**   
and the web version of the app on  
**<http://localhost:5001>**

For specifics or alternatives see the `README.md` of the subprojects.