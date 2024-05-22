# Flow of API calls from the app to the server

## Login

- TBD

## Start of simulation

- TBD

## Visiting patients and performing actions

1. Get single patient by ID/TAN `/{gameId}/{userTan}/patients` or list of all
   patients `/{gameId}/{userTan}/patients/{patientId}`.
2. Get available actions `/{gameId}/{userTan}/actions` and resources `/{gameId}/{userTan}/locations`.
3. Perform an action `/{gameId}/{userTan}/actions/{actionId}`(POST).
    - Return the id of the performed action to retrieve the result later.
    - We might have to send the consumed resources or does the backend organize this automatically?
4. Get result of performed action `/{gameId}/{userTan}/actions/result/{performedActionId}`.
5. Start over / update patients, resources and actions.

# Discussion

- `gameId` and `userTan` in path or as parameters?
- `userTan` might not be needed for all requests
    - patientList not needed?
    - patient to track player location?
    - actions and locations might be player or role specific
- Does the backend automatically decide which resources are consumed or do we have to send them in the request?
- Is the performedActionId enough for the frontend? We just need it to fetch the result later?