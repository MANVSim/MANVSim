import json

from server.executions.entities.location import Location
from server.executions.entities.resource_type import ResourceType


class Resource:

    def __init__(self, id: int, location: Location, resource_type: ResourceType, quantity: int):
        self.id = id
        self.location = location
        self.resource_type = resource_type
        self.quantity = quantity

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'location': self.location.id if shallow else self.location.to_dict(),
            'resource_type': self.resource_type.id if shallow else self.resource_type.to_dict(),
            'quantity': self.quantity
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
