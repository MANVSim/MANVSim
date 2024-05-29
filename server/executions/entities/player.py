import json
from enum import IntEnum

from executions.entities.location import Location


class Player:

    class Role(IntEnum):
        """
        Models the players role in the scenario. Each role has an integer value of 'power' assigned that has no meaning
        other than to define an order between the different roles.

        For example, NOTARZT > NOTFALLSANITAETER = True. This can be used to check the eligibility of a player to
        perform an action.
        """
        UNKNOWN = -1
        ORGL = 0  # Organisatorischer Leiter Rettungsdienst
        RETTUNGSASSISTENT = 100
        RETTUNGSSANITAETER = 200
        NOTFALLSANITAETER = 300
        NOTARZT = 400

    def __init__(self, tan: str, name: str, role: 'Player.Role', alerted: bool, activation_delay_sec: int,
                 location: Location, accessible_locations: set[Location]):
        self.tan = tan
        self.name = name
        self.role = role
        self.alerted = alerted
        self.activation_delay_sec = activation_delay_sec
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
            'role': self.role.name,
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
