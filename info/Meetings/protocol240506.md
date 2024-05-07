# Meeting 06.05.24

## Presentation Of Work

### Louis

- DB Scheme updated
- Initial Setup Script

#### Questions?

- Fill DB via SQL or via django?

### Simon

- Visualization of DB scheme
- Think about correct mapping of resources

#### Questions?

- Why do we have mappings from resources/locations to their respective type?
  - original idea was to distinguish between static (theoretical) and dynamic (actual) resources
  - remove one of them
    - introduce mapping for runtime
- What is this JSON?
  - Scenario setup?
  - Need for runtime representation
  - Different JSON for communication between server & client
    - OpenAPI?

### Yannick

- Diagram
  - Yannick adjusted diagram
- Django uses _many_ components
  - Could bloat code at beginning/for new components
- Yannick approves Event Sourcing
  - Allows for replays of scenarios
  - instantly log events to fast logging alternative because louis does not like sqlite
  - log different executions separate

#### Questions

- Scenario Admin vs. Scenario Manager
  - Admin creates scenarios
  - Manager "leads" scenario executions
- clear separation of scenario and execution

### Jon

- Talked about project structure
- merged branches
- not much functionality
  - mostly style and static content
- Dummy page
  - enter TAN
  - scan QR Code
- Search through locations and resources
- Show, when other player is currently at a patient
- Notification Tab

#### Questions

- Do we select actions and see required resources? Or do we select resources and see available actions?
  - Serious Game
  - Map from resource to action

### Lukas

- Setup Flutter Project MD
  - For development, simply follow official flutter guide
  - For running, follow the guide
    - Run web app via docker

## TODO

- Simon & Yannick
  - API design and basic model development
- Jon & Lukas
  - App development
    - either store all actions etc locally and "fake" requests
    - or talk with API
- Peter
  - management tool (Game Master)
- Louis
  - talk with Peter
  - logging
- Open topics
  - image management
