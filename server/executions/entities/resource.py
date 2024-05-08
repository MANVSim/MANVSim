from executions.entities.location import Location
from executions.entities.resource_type import ResourceType


class Resource:

    def __init__(self, id: int, location: Location, resource_type: ResourceType, quantity: int):
        self.id = id
        self.location = location
        self.resource_type = resource_type
        self.quantity = quantity
