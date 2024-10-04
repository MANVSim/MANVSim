# Documentation MANVSim: Server

This directory contains documentation about server architecture and software processes.

## Contents

- [Game-API](api_game/README.md)
- [Media-API](api_media/README.md)
- [Database](database/MANV_scheme.svg)
- [Webinterface](../web/README.md)
- [Architecure and general Documentation](README.md)

## Workflow

The game preparation and running phases are separated by the database:
![Workflow Graph](./entity/entity_flow_chart.svg)

An idea of the game-flow can be presented by the following image. This docu is not final yet.
![Workflow Graph](./game_flow_chart.svg)

## Architecture

### Component Diagram

![Component Diagram for the Flask Server Application](component_diagram.svg)

- **Server** is the main part of the backend. It contains the key components _Execution-Management_, _Scenario-Management_, and _Administration_ (User-/Security-Management).
- **Website** is the frontend part of the server. It is accessible through a WebAPI endpoints and separated from the Game API.
- **(Web-)App** is the mobile-frontend part of MANVSim and is documented [here](./../app/). In this context it is connected to the Execution component, by requesting the current game state.
- **Application Admin** is the role regarding any administration work on the web application.
- **Game Master** is the role regarding any execution work on a specific scenario. Ideally only a Game Master can manage the scenario he gets access to.
- **Scenario Admin** is the role regarding any game preparation. The role creates a game along with its required resources.
- **TAN Player** is the Game Attendant participating in a scenario. The role is no user of the Web Application of the Server

## Game Implementation
Without going into detail, this section provides an overview of the key points of the game related endpoints. Make
sure to understand the concepts of the implementation before making any improvements. Due to its game characteristics
changes in the design leads to bugs and failures of other endpoints.

### Data Structure

[Entity Model](./entity/entity_relation_runtime.svg)

### Most important Endpoints

- **Location-Management (take-to | put-to)** - These endpoints manage the inventory of a player. It allows to access other locations or leave other locations behind.
Both endpoints are influenced by the current position of the player and access possibilities. That leads to a rather complex case check. The attribute 'accessible_location' 
represents a players inventory. This list is modified by both endpoints. Either a location is added or removed (nesting is possible).
- **Action-Management (perform | perform/result)** - These endpoints influence the patients state by using resources. The server executes the desired action, depending
on the accessible resources in the location tree. When the player is allowed to perform the desired action the action is queued on the patient and the state is updated.
Only the client tracks the time of any performed action. The server changes the state instantly, after the result is collected.

- **Future-Work**: It is advisable to add resources specifically to the inventory management. So far only locations can be transferred to/from the inventory.
Further the locations characteristics can be modified to prevent, that player put a backpack into another backpack. Another idea is to block patients
if specific actions are queued to prevent unrealistic action combinations.