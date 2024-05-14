import json


class Action:

    def __init__(self, id: int, name: str, result: str, picture_ref: str, duration_sec: int,
                 resources_needed: list[str]):
        self.id = id
        self.name = name
        self.result = result  # FIXME: Maybe replace by JSON datatype
        self.picture_ref = picture_ref  # Reference to picture
        self.duration_sec = duration_sec  # FIXME: Maybe replace by standardized time format
        self.resources_needed = resources_needed

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'result': self.result,
            'picture_ref': self.picture_ref,
            'duration_sec': self.duration_sec,
            'resources_needed': self.resources_needed
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
