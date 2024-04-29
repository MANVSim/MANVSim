# Meeting 29.04.2024

## Presentation of work

### Jon

- Flutter app
  - better for multiplatform
- simple patient list
  - only prototype (navigation will probably need improvement)
- large community, not many libraries from google
  - open source HTTP library

#### TODO

- evaluate usability of websockets
- Requirements & Getting Started for Flutter app
  - `INSTALL.md`
  - Download flutter SDk

### Lukas

- simple login
  - TAN & example URL
  - (not working) QRC scan
  - enter name
  - wait for simulation start

#### TODO

- structure App
- wait for server data (dynamic flow of application in order to wait for delays etc.)

### Simon

- basic communication evaluation
- REST...
  - classic interface
  - CRUD
  - unidirectional communication
- ...vs. WebSockets...
  - bidirectional communication
  - many connections
    - complex management
    - synchronization not simple
- ...vs. Message-Queue (e.g., Kafka, RabbitMQ, etc.)...
  - high throughput
  - client needs to keep track of all information
  - possibly higher latency
- ...vs. hybrid solutions
  - REST & WS combined

#### Conclusion

- start with REST
- think about WS when needed

### Louis

- nothing really changed
  - however, resources got removed (not good)

#### Discussion

- initial download of all data?
  - prevents high traffic during execution
- on demand download of required data
  - prevents unneeded download of data
- how to store images?
  - in DB?
    - content probably not
    - store name/meta information (e.g., location in file system)
  - in directories (on the server)?
    - better
    - mapping from references to actual image
  - special format for text & images (text to image reference)
  - file upload for images
    - original or artificial file name
  - give

#### TODO

- add resources back to DB scheme
- image table in database
- tables for scenario admin and scenario manager

### Peter

- admin login works
- user creation works
- user login works

> everything done via django internals

#### TODO

- add django tables to scheme
- getting started guide
  - script/docker

### Yannick

- project works
  - add prios if needed
  - use milestones?
- branching solution
  - small work packages
- pipelines ci/cd
  - separate branches for app and server
    - Louis: not good, rather have a common branch to avoid conflicts & bugs

## General Ideas

- setup script to create setup with initial data
  - start server with local code
  - use docker/docker compose

## TODOS For Next Time

- Louis:
  - Add resources to DB scheme
  - Add django internals to DB scheme
  - Create initial setup for server (via Docker)
- Jon & Lukas:
  - Improve App
  - multiple views
- Simon:
  - specification for transmitting scenario to app
- Peter:
  - work with django and get to know HTML
  - !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  - !!!!!!!!!!!!!!!!!!!! REMOVE DJANGO ADMIN FROM ADMIN PANEL !!!!!!!!!!!!!!!!!!!!
  - !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  - fix zoom
- Yannick:
  - GitHub Actions
  - state definition in django
    - what can be stored in storage
    - what needs to be saved to database
- Frank:
  - server
