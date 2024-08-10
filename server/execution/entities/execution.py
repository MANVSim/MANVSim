import json
from enum import Enum

from werkzeug.exceptions import InternalServerError, BadRequest

import models
from app_config import db
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

    def __init__(self, id: int, name: str, scenario: Scenario,
                 players: dict[str, Player], status: Status,
                 starting_time: int = -1):
        self.id = id
        self.name = name
        self.scenario = scenario
        self.players = players
        self.status = status
        self.starting_time = starting_time
        self.notifications = []

    def start_execution(self):
        """ Performs the execution start protocol. """
        if not self.scenario:
            raise InternalServerError("Execution without a scenario detected.")
        elif self.status == Execution.Status.PENDING:
            # enables the patients activity-diagrams
            self.scenario.run_patients()
        else:
            raise BadRequest("Process manipulation detected. Execution must be "
                             "PENDING before start.")

    def pause_execution(self):
        """ Pauses execution components. """
        if not self.scenario:
            raise InternalServerError("Execution without a scenario detected.")
        elif self.status == Execution.Status.RUNNING:
            # enables the patients activity-diagrams
            self.scenario.pause_patients()
        else:
            raise BadRequest("Process manipulation detected. Execution must be "
                             "RUNNING before pause.")

    def __repr__(self):
        return (
            f"Execution(id={self.id!r}, scenario={self.scenario!r}, \
            players={self.players!r}, status={self.status!r}, \
            starting_time={self.starting_time!r})")

    def to_dict(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns all fields of this class in a dictionary. By default, all nested
        objects are included. In case the 'shallow'-flag is set, only the object
        reference in form of a unique identifier is included. Via exclude and
        include, lists of attributes can be included or excluded from the
        result.
        """
        result = {
            'id': self.id,
            'name': self.name,
            'scenario': self.scenario.id if shallow else self.scenario.to_dict(),
            'starting_time': self.starting_time,
            'players': [player.tan if shallow else player.to_dict() for player
                        in list(self.players.values())],
            'status': self.status.name
        }

        if include:
            result = {key: result[key] for key in include if key in result}
        if exclude:
            for key in exclude:
                result.pop(key, None)

        return result

    def to_json(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns this object as a JSON. By default, all nested objects are
        included. In case the 'shallow'-flag is set, only the object reference
        in form of a unique identifier is included. Via exclude and included,
        lists of attributes can be included or excluded from the result.
        """
        return json.dumps(self.to_dict(shallow, include, exclude))

    def add_new_player(self, role: int, location: int):
        from utils.tans import unique
        from execution.run import register_player
        from execution.services.entityloader import load_location
        from execution.services.entityloader import load_role

        tan = str(unique())
        db.session.add(models.Player(tan=tan, execution_id=self.id,
                                     location_id=0, role_id=role, alerted=False,
                                     activation_delay_sec=0))  # pyright: ignore [reportCallIssue]
        db.session.commit()
        new_player = Player(tan, None, False, 0,
                            load_location(location), set(), load_role(role))
        self.players[tan] = new_player
        register_player(self.id, [new_player])
