import json

from executions.entities.location import Location
from executions.entities.role import Role


class Player:

    def __init__(self, tan: str, name: str | None, alerted: bool, activation_delay_sec: int, location: Location | None,
                 accessible_locations: set[Location], role: Role | None = None):
        self.tan = tan
        self.name = name
        self.role = role
        self.alerted = alerted
        self.activation_delay_sec = activation_delay_sec
        self.location = location
        self.accessible_locations = accessible_locations

    def __repr__(self):
        return (f"Player(tan={self.tan!r}, name={self.name!r}, alerted={self.alerted!r}, "
                f"activation_delay_sec={self.activation_delay_sec!r}, location={self.location!r}, "
                f"accessible_locations={self.accessible_locations!r}, role={self.role!r})")

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case thes
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'tan': self.tan,
            'name': self.name,
            'role': (self.role if self.role is None else self.role.name),
            'alerted': self.alerted,
            'activation_delay_sec': self.activation_delay_sec,
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
