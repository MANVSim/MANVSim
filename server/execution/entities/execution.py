import json
from enum import Enum

from execution.entities.player import Player
from execution.entities.scenario import Scenario
from app_config import db
import models


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

    def add_new_player(self, role: int, location: int):
        from utils.tans import uniques
        from execution.run import register_player
        tan = str(uniques(1)[0])
        db.session.add(models.Player(tan=tan, execution_id=self.id,
                                     location_id=0, role_id=role, alerted=False, activation_delay_sec=0))  # pyright: ignore [reportCallIssue]
        db.session.commit()
        new_player = Player(tan, None, False, 0, None, set(), None)
        self.players[tan] = new_player
        register_player(self.id, [])
