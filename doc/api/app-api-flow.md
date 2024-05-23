# Flow of API calls from the app to the server

## Login

- TBD

## Start of simulation

- TBD

## Visiting patients and performing actions

1. Get single patient by ID/TAN `/{gameId}/patients` (or list of all
   patients `/{gameId}/patients/{patientId}`).
2. Get available actions `/{gameId}/actions` (for role) and resources `/{gameId}/locations`.
3. Perform an action `/{gameId}/actions/{actionId}`(POST).
    - Return the id of the performed action to retrieve the result later.
    - We send the ids of the resources for the action in the request body.
4. Get result of performed action `/{gameId}/actions/result/{performedActionId}`.
5. Start over / update patients, resources and actions.

# Discussion

- `gameId` and `userTan` in header (or path or parameter)?
  - `userTan` and maybe also `gameId` in HTTP header (e.g. Authorization)?
- `userTan` might not be needed for all requests 
    - use for authorization and location mapping/tracking
    - actions and locations might be player or role specific
- Does the backend automatically decide which resources are consumed or do we have to send them in the request?
  - We split the work and send the resourceIds in the request.
- Is the performedActionId enough for the frontend? We just need it to fetch the result later?
- Add `v1/` to the beginning of the urls to specify API version?