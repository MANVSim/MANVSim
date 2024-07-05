import json
from enum import Enum

from execution.entities.player import Player
from execution.entities.scenario import Scenario


class Execution:

    class Status(Enum):
        RUNNING = "running"
        PENDING = "pending"
        FINISHED = "finished"
        UNKNOWN = "unknown"

        def __repr__(self):
            return self.name

    def __init__(self, id: int, name: str, scenario: Scenario, players: dict[str, Player], status: Status,
                 starting_time: int = -1):
        self.id = id
        self.name = name
        self.scenario = scenario
        self.players = players
        self.status = status
        self.starting_time = starting_time
        self.notifications = []

    def __repr__(self):
        return (f"Execution(id={self.id!r}, scenario={self.scenario!r}, players={self.players!r}, "
                f"status={self.status!r}, starting_time={self.starting_time!r})")

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'scenario': self.scenario.id if shallow else self.scenario.to_dict(),
            'starting_time': self.starting_time,
            'players': [player.tan if shallow else player.to_dict() for player in list(self.players.values())],
            'status': self.status.name
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
