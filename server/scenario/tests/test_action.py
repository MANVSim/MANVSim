import models
from scenario.web_api.utils import update_media


def test_media():
    """ Test designed for debugger analysis. """
    json_string = """[
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
    ]"""

    action = models.Action(
        id=1,
        name="TestAction",
        media_refs=json_string
    )

    media_add = [
        {
            "media_type": "AUDIO",
            "title": "New Sample Audio",
            "text": None,
            "media_reference": "http://example.com/new_audio.mp3"
        },
        {
            "media_type": "IMAGE",
            "title": "New Image",
            "text": "An example image",
            "media_reference": "http://example.com/new_image.jpg"
        }

    ]

    media_del = [
        {
            "media_type": "AUDIO",
            "title": "Sample Audio",
            "text": None,
            "media_reference": "http://example.com/audio.mp3"
        },
        {
            "media_type": "TEXT",
            "title": "False Sample Text",
            "text": "This is a sample text.",
            "media_reference": None
        }
    ]

    update_media(action, media_refs_add=media_add, media_refs_del=media_del)
    assert action.media_refs
