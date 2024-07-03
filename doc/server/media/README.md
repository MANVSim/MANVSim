# MANVSim Media API

### Access Media Files

To retrieve a media file given as `picture_ref` attribute of an entity can be done by requesting `GET` on `http://[server.url]/[picture_ref]`. The picture reference already includes the information which of the two API endpoints should be addressed, so no explicit calling of the API is required.

For possible responses and media types see [MANVSim Media API](media_api.yml).

### Upload Media Files

The administrators of scenarios can upload additional media files that can be referenced in entities. Therefore, a `POST` containing the file as binary can be send to `http://[server.url]/media/instance/[filename]`. Only authenticated users can access this endpoint. A CSRF-Token may be required.

For additional information on possible responses and allowed file formats see [MANVSim Media API](media_api.yml).