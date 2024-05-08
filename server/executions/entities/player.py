from executions.entities.location import Location


class Player:

    def __init__(self, tan: str, name: str, location: Location,
                 accessible_locations: list[Location]):
        self.tan = tan
        self.name = name
        self.location = location
        self.accessible_locations = accessible_locations
