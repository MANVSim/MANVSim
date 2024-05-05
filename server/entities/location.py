from location_type import LocationType


class Location:

    def __init__(self, id: int, name: str, location: 'Location', location_type: LocationType):
        self.id = id
        self.name = name
        self.location = location
        self.location_type = location_type
