# Documentation MANVSim:Server

This document contains relevant documentation about server architecture and software processes.

## Content

- Architecture
- tbd

## Architecture

### Component Diagram

![Component Diagram for the Django Application](Architecture%20Backend%20Components.svg)

- **Server** is the main component of the backend. It contains multiple components, like _User Management_, _Scenario Management_, _Execution Management_, (...). It is categorized into three sections: Administration, Game Preparation, Game Execution.
- **App** is the frontend component of MANVSim and is documented [here](./../app/). In this context it is presented as part of the Game Execution, by performing requests on the current game state.
- **Application Admin** is the role regarding any administration work on the web application.
- **Game Master** is the role regarding any execution work on a specific scenario. Only one Game Master can manage one scenario.
- **Scenario Admin** is the role regarding any game preparation. The role creates a game along with its required resources.
- **TAN Player** is the Game Attendant participating in a scenario. The role is no user of the Web Application of the Server

### Scenario Workflow

![Scenario Workflow](Scenario%20Flow.svg)