import json

import models
from media.media_data import MediaData


def update_media(dbo: models.Action | models.Location | models.Resource,
                 media_refs_add: list[dict] | None = None,
                 media_refs_del: list[dict] | None = None):
    """ Deletes/Adds media-data based on parameters. """
    if media_refs_del is None:
        media_refs_del = []
    if media_refs_add is None:
        media_refs_add = []

    media_refs: list[dict] = json.loads(dbo.media_refs)
    for del_media in media_refs_del:
        media_refs = __remove_media(media_refs, del_media)

    # Add
    for add_media in media_refs_add:
        media_refs.append(add_media)

    dbo.media_refs = media_refs


def __remove_media(media_refs, del_media):
    """ Removes json objects out of media-json-list. """
    new_media_refs = []
    for media in media_refs:
        if media["media_type"] != media["media_type"]:
            # different media type then required
            new_media_refs.append(media)

        elif (del_media["media_type"] == MediaData.Type.TEXT
                and del_media["title"] != media["title"]):
            # Title of text is primary key
            new_media_refs.append(media)

        elif (del_media["title"] != media["title"]
              or del_media["media_reference"] != media["media_reference"]):
            # title and reference are primary key for other media types
            new_media_refs.append(media)
        else:
            # Primary Key and Type match
            continue

    return new_media_refs
