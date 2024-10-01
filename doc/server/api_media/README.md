# MANVSim Media API


### Access Media Files

Retrieving a media file, given as part of the `media_reference` attribute of an entity, can be achieved by requesting `GET` on `http://[server.url]/[media_reference]`. The picture reference already includes the information which of the two API endpoints should be addressed, so no explicit calling of the API is required.

For possible responses and media types see [MANVSim Media API](media_api.yml).


### Upload Media Files

The administrators of scenarios are able upload additional media files that can be referenced in entities. Therefore, a `POST` containing the file as binary can be send to `http://[server.url]/media/[filename]`. Only authenticated users can access this endpoint. A CSRF-Token may be required. For a successful request the server responds with an entry of the [Media Reference JSON](#media-reference-json-schema) array.

For additional information on possible responses and allowed file formats see [MANVSim Media API](media_api.yml).

As raw text is only stored in memory, the Media API provides an additional endpoint `http://[server.url]/media/txt` that takes `text` and/or `title` as form parameters and returns an entry of the [Media Reference JSON](#media-reference-json-schema) array.


### Setting Media References

Media references for entities are lists of the `MediaData` datatype, which includes attributes such as type of the reference (image, video, audio, text) or a reference path to a media file `media_reference` (formerly known as `picture_ref`).

### Directory Structure

Accessible files are stored in two different directories:

1. `server/media/static/` - contains predefined media files that are included with every instance of the server
2. `server/media/instance/` - contains user-uploaded media files that are specific to this single instance of the server

According to that, users can only upload files to the second directory, while (permanent) changes to the first directory have to go through the build and deployment process.


### Media Reference JSON Schema

The media reference attribute of entities has the following structure:

```json
{
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "media_type": {
        "type": "string",
        "enum": ["AUDIO", "IMAGE", "VIDEO", "TEXT"],
        "description": "The type of the media content."
      },
      "title": {
        "type": ["string", "null"],
        "description": "The title of the media content, if applicable."
      },
      "text": {
        "type": ["string", "null"],
        "description": "The text content, if applicable."
      },
      "media_reference": {
        "type": ["string", "null"],
        "description": "A reference to the media content, such as a URL or file path."
      }
    },
    "required": ["media_type"],
    "additionalProperties": false
  }
}
```

#### Example:

```json
[
  {
    "media_type": "AUDIO",
    "title": "Sample Audio",
    "text": null,
    "media_reference": "http://example.com/audio.mp3"
  },
  {
    "media_type": "IMAGE",
    "title": null,
    "text": "An example image",
    "media_reference": "http://example.com/image.jpg"
  },
  {
    "media_type": "VIDEO",
    "title": "Sample Video",
    "text": null,
    "media_reference": "http://example.com/video.mp4"
  },
  {
    "media_type": "TEXT",
    "title": "Sample Text",
    "text": "This is a sample text.",
    "media_reference": null
  }
]
```


### Future Work

- Allow batch requests
- Organize user-uploaded media in subdirectories (e.g. by scenario)
- ...