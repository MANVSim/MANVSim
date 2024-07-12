# Documentation MANVSim: Server

This directory contains documentation about server architecture and software processes.

## Contents

- [Game-API](api_game/README.md)
- [Media-API](api_media/README.md)
- [Database](database/MANV_scheme.svg)
- [Webinterface](web/README.md)
- [Architecure and general Documentation](README.md)

## Architecture

### Component Diagram

![Component Diagram for the Flask Server Application](component_diagram.svg)

- **Server** is the main component of the backend. It contains the key components _Execution-Management_, _Scenario-Management_, and _Administration_ (User-/Security-Management).
- **App** is the frontend component of MANVSim and is documented [here](./../app/). In this context it is presented as part of the Game Execution, by performing requests on the current game state.
- **Application Admin** is the role regarding any administration work on the web application.
- **Game Master** is the role regarding any execution work on a specific scenario. Only one Game Master can manage one scenario.
- **Scenario Admin** is the role regarding any game preparation. The role creates a game along with its required resources.
- **TAN Player** is the Game Attendant participating in a scenario. The role is no user of the Web Application of the Server

### Scenario Entity Workflow

![Scenario Workflow](entity_flow_chart.svg)