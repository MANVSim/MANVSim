import json


class Location:

    def __init__(self, id: int, name: str, picture_ref: str, location: 'Location'):
        self.id = id
        self.name = name
        self.picture_ref = picture_ref  # Reference to picture
        self.location = location

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'picture_ref': self.picture_ref,
            'location': self.location.id if shallow else self.location.to_dict()
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
