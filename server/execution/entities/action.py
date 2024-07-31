import json


class Action:

    def __init__(self, id: int, name: str, results: list[str], picture_ref: str,
                 duration_sec: int, resources_needed: list[str],
                 required_power: int = 0):
        self.id = id
        self.name = name
        self.results = results  # list of condition keys to reveal on a patient
        self.picture_ref = picture_ref  # Reference to picture
        self.duration_sec = duration_sec
        self.required_power = required_power  # Power of Role
        self.resources_needed = resources_needed  # Names of resources needed to perform action

    def to_dict(self, include: list | None = None, exclude: list | None = None):
        """
        Returns all fields of this class in a dictionary. Via exclude and
        include, lists of attributes can be included or excluded from the
        result.
        """
        result = {
            'id': self.id,
            'name': self.name,
            'results': self.results,
            'picture_ref': self.picture_ref,
            'duration_sec': self.duration_sec,
            'required_role': self.required_power,
            'resources_needed': self.resources_needed
        }

        if include:
            result = {key: result[key] for key in include if key in result}
        if exclude:
            for key in exclude:
                result.pop(key, None)

        return result

    def to_json(self, include: list | None = None, exclude: list | None = None):
        """
        Returns this object as a JSON. Via exclude and include, lists of
        attributes can be included or excluded from the result.
        """
        return json.dumps(self.to_dict(include, exclude))
