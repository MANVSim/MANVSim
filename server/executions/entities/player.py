import json

from executions.entities.location import Location


class Player:

    def __init__(self, tan: str, name: str, location: Location, accessible_locations: set[Location]):
        self.tan = tan
        self.name = name
        self.location = location
        self.accessible_locations = accessible_locations

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'tan': self.tan,
            'name': self.name,
            'location': self.location.id if shallow else self.location.to_dict(),
            'accessible_locations': [location.id if shallow else location.to_dict() for location in
                                     self.accessible_locations]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
