# Flow of API calls from the app to the server

## Login

- The player inputs his TAN (and the server URL), the app makes a login request
    - On success the server returns a JWT which maps player and execution.
- If the player hasn't logged in before, he gets to choose a name.

## Start of simulation

- The player enters the waiting screen. The app polls for `starting_time` and `travel_time`, starting the timer, once it
  is known.
- When the arrival time is known by the client an alarm/notification is triggered and the countdown to arrival on site
  begins.
- After arrival/end of timer the user is automatically forwarded to the simulation part of the app.

## Visiting patients and performing actions

1. Get single patient by ID/TAN `/patients` with `patientId` as parameter (or list of all
   patients `/patients/all`).
2. Get available actions `/actions` (for role) and resources `/locations`.
3. Perform an action `/actions`(POST) with `actionId` as parameter.
    - Return the id of the performed action to retrieve the result later.
    - We send the ids of the resources for the action in the request body.
        - If we use the same type of resource multiple times, the ID is in the list the according amount of times
4. Get result of performed action `/actions/result` with `performedActionId` as parameter.
5. Start over / update patients, resources and actions.

# Multimedia JSON format

We want a format which may contain any number of texts and images (as reference).  
Places where this may be used is `performedActionResult` or description of patients, resources or actions.

Example:

```json
[
  {
    "text": "Hallo, dies ist mein Text",
    "imageRef": "/assets/some_image.jpg"
  },
  {
    "text": "Hallo, dies ist mein zweiter Text",
    "imageRef": "/assets/some__other_image.jpg"
  },
  {
    "text": "Hallo, dies ist mein dritter Text"
  }
]
```

# Discussion

- `gameId` and `userTan` in header (or path or parameter)?
    - `userTan` and `gameId` in HTTP Authorization header in a JWT
- `userTan` might not be needed for all requests
    - use for authorization and location/resource mapping/tracking
    - resources are player (location) specific, actions are role specific
- Does the backend automatically decide which resources are consumed or do we have to send them in the request?
    - We split the work and send the resourceIds in the request.
- Is the performedActionId enough for the frontend? We just need it to fetch the result later?
- Add `v1/` to the beginning of the urls to specify API version?
    - Yes, to allow breaking changes in the API 