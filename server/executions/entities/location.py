import json

from executions.entities.resource import Resource


class Location:

    def __init__(self, id: int, name: str, picture_ref: str, resources: list[Resource] = None,
                 locations: set['Location'] = None):
        if resources is None:
            resources = []
        if locations is None:
            locations = []

        self.id = id
        self.name = name
        self.picture_ref = picture_ref  # Reference to picture
        self.resources = resources
        self.locations = locations

    def get_location_by_id(self, id):
        return next((location for location in self.locations if location.id == id), None)

    def remove_location_by_id(self, id):
        self.locations = {location for location in self.locations if location.id != id}

    def remove_location_by_value(self, value):
        self.locations = self.locations.remove(value)

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'picture_ref': self.picture_ref,
            'resources': [resource.id if shallow else resource.to_dict() for resource in self.resources],
            'location': [location.id if shallow else location.to_dict() for location in self.locations]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
