import json

from media.media_data import MediaData


class Action:

    def __init__(self, id: int, name: str, results: list[str],
                 media_references: list[MediaData],
                 duration_sec: int, resources_needed: list[str],
                 required_power: int = 0):
        self.id = id
        self.name = name
        self.results = results  # list of condition keys to reveal on a patient
        self.media_references = media_references
        self.duration_sec = duration_sec
        self.required_power = required_power  # Power of Role
        self.resources_needed = resources_needed  # Names of resources needed to perform action

    def to_dict(self):
        """
        Returns all fields of this class in a dictionary. By default, all nested
        objects are included. In case the 'shallow'-flag is set, only the object
        reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'results': self.results,
            'media_references': [media_ref.to_dict() for media_ref in
                                 self.media_references],
            'duration_sec': self.duration_sec,
            'required_role': self.required_power,
            'resources_needed': self.resources_needed
        }

    def to_json(self):
        """
        Returns this object as a JSON. By default, all nested objects are
        included. In case the 'shallow'-flag is set, only the object reference
        in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict())
