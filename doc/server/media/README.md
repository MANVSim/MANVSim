# MANVSim Media API

### Access Media Files

Retrieving a media file, given as `picture_ref` attribute of an entity, can be achieved by requesting `GET` on `http://[server.url]/[picture_ref]`. The picture reference already includes the information which of the two API endpoints should be addressed, so no explicit calling of the API is required.

For possible responses and media types see [MANVSim Media API](media_api.yml).

### Upload Media Files

The administrators of scenarios are able upload additional media files that can be referenced in entities. Therefore, a `POST` containing the file as binary can be send to `http://[server.url]/media/instance/[filename]`. Only authenticated users can access this endpoint. A CSRF-Token may be required.

For additional information on possible responses and allowed file formats see [MANVSim Media API](media_api.yml).

### Directory Structure

Accessible files are stored in two different directories:

1. `server/media/static/` - contains predefined media files that are included with every instance of the server
2. `server/media/instance/` - contains user-uploaded media files that are specific to this single instance of the server

According to that, users can only upload files to the second directory, while (permanent) changes to the first directory have to go through the build and deployment process.

### Future Work

- Add support for different media formats (currently only images)
  - add subdirectories accordingly
- Allow batch requests
- Organize user-uploaded media in subdirectories (e.g. by scenario) 
- ...