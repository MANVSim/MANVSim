import json

from execution.entities.location import Location
from execution.entities.role import Role
from execution.utils.timeoutlock import TimeoutLock
from utils import time


class Player:

    def __init__(self, tan: str, name: str | None, alerted: bool,
                 activation_delay_sec: int, location: Location | None,
                 accessible_locations: set[Location], role: Role | None = None,
                 logged_in: bool = False):
        self.tan = tan
        self.name = name
        self.role = role
        self.alerted = alerted
        self.activation_delay_sec = activation_delay_sec
        self.location = location
        self.accessible_locations = accessible_locations
        self.logged_in = logged_in  # is toggled upon first login

        self.alerted_timestamp = 0
        self.lock = TimeoutLock()

    def alert(self):
        if not self.alerted:
            self.alerted = True
            self.alerted_timestamp = time.current_time_s()

    def remove_alert(self):
        if self.alerted:
            self.alerted = False
            self.alerted_timestamp = 0

    def __repr__(self):
        return (
            f"Player(tan={self.tan!r}, \
            name={self.name!r}, \
            alerted={self.alerted!r}, \
            activation_delay_sec={self.activation_delay_sec!r}, \
            location={self.location!r}, \
            accessible_locations={self.accessible_locations!r}, \
            role={self.role!r})"
        )

    def to_dict(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns all fields of this class in a dictionary. By default, all nested
        objects are included. In case the 'shallow'-flag is set, only the object
        reference in form of a unique identifier is included. Via exclude and
        include, lists of attributes can be included or excluded from the
        result.
        """
        res_dict = {
            'tan': self.tan,
            'name': self.name,
            'role': self.role if self.role is None else self.role.name,
            'alerted': self.alerted,
            'activation_delay_sec': self.activation_delay_sec,
            'location': self.location if not self.location else
            (self.location.id if shallow else self.location.to_dict()),
            'accessible_locations': [
                location.id if shallow else location.to_dict() for location in
                self.accessible_locations],
            'logged_in': self.logged_in
        }

        if include:
            res_dict = {key: res_dict[key] for key in include if
                        key in res_dict}
        if exclude:
            for key in exclude:
                res_dict.pop(key, None)

        return res_dict

    def to_json(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns this object as a JSON. By default, all nested objects are
        included. In case the 'shallow'-flag is set, only the object reference
        in form of a unique identifier is included. Via exclude and
        included, lists of attributes can be included or excluded from the
        result.
        """
        return json.dumps(self.to_dict(shallow, include, exclude))
