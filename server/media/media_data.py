import json
from enum import Enum
from typing import Optional, List


class MediaData:

    class Type(Enum):
        AUDIO = "AUDIO"
        IMAGE = "IMAGE"
        VIDEO = "VIDEO"
        TEXT = "TEXT"

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
