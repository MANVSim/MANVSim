import json
from enum import StrEnum
from typing import Optional


class MediaData:

    class Type(StrEnum):
        AUDIO = "AUDIO"
        IMAGE = "IMAGE"
        VIDEO = "VIDEO"
        TEXT = "TEXT"

    ALLOWED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"}
    ALLOWED_VIDEO_EXTENSIONS = {".mp4", ".mov", ".mkv"}
    ALLOWED_TEXT_EXTENSIONS = {".txt"}
    ALLOWED_AUDIO_EXTENSIONS = {".mp3", ".wav", ".ogg", ".flac"}

    def __init__(self, media_type: 'MediaData.Type',
                 title: Optional[str] = None,
                 text: Optional[str] = None,
                 media_reference: Optional[str] = None):
        self.media_type = media_type
        self.title = title
        self.text = text
        self.media_reference = media_reference

    def to_dict(self):
        return {
            "media_type": self.media_type.value,
            "title": self.title,
            "text": self.text,
            "media_reference": self.media_reference
        }

    @classmethod
    def from_dict(cls, data) -> 'MediaData':
        media_type = cls.Type(data["media_type"])
        title = data.get("title")
        text = data.get("text")
        media_reference = data.get("media_reference")
        return cls(media_type, title, text, media_reference)

    def to_json(self):
        return json.dumps(self.to_dict())

    @classmethod
    def from_json(cls, json_str) -> 'MediaData':
        data = json.loads(json_str)
        return cls.from_dict(data)

    @staticmethod
    def list_to_json(media_data_list: list['MediaData']) -> str:
        return json.dumps(
            [media_data.to_dict() for media_data in media_data_list])

    @staticmethod
    def list_from_json(json_str: str) -> list['MediaData']:
        data_list = json.loads(json_str)
        return [MediaData.from_dict(data) for data in data_list]

    @staticmethod
    def is_allowed_extension(extension: str) -> bool:
        return (extension in MediaData.ALLOWED_IMAGE_EXTENSIONS |
                MediaData.ALLOWED_VIDEO_EXTENSIONS |
                MediaData.ALLOWED_TEXT_EXTENSIONS |
                MediaData.ALLOWED_AUDIO_EXTENSIONS)

    @classmethod
    def new_text(cls, text: str, title: Optional[str] = None) -> 'MediaData':
        return cls(media_type=cls.Type.TEXT, text=text, title=title)

    @classmethod
    def new_text_file(cls, text_reference: str, title: Optional[str] = None) -> 'MediaData':
        return cls(media_type=cls.Type.TEXT, title=title, media_reference=text_reference)

    @classmethod
    def new_image(cls, image_reference: str,
                  title: Optional[str] = None) -> 'MediaData':
        return cls(media_type=cls.Type.IMAGE, media_reference=image_reference,
                   title=title)

    @classmethod
    def new_video(cls, video_reference: str,
                  title: Optional[str] = None) -> 'MediaData':
        return cls(media_type=cls.Type.IMAGE, media_reference=video_reference,
                   title=title)

    @classmethod
    def new_audio(cls, audio_reference: str,
              title: Optional[str] = None) -> 'MediaData':
        return cls(media_type=cls.Type.IMAGE, media_reference=audio_reference,
                   title=title)
