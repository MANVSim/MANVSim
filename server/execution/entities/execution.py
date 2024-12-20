import json
import logging
from enum import Enum

from flask import current_app
from werkzeug.exceptions import InternalServerError, BadRequest

import models
import utils.time
from app_config import db
from execution.entities.event import Event
from execution.entities.player import Player
from execution.entities.scenario import Scenario


# pyright: reportCallIssue=false
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
            if not self.starting_time:
                self.starting_time = utils.time.current_time_s()
            Event.execution_started(self.id, self.to_json()).log()
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
            Event.execution_paused(self.id).log()
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

    def get_location_for_player(self, vehicle_name):
        if not self.scenario:
            return None

        locations = self.scenario.locations

        if not locations:
            return None

        for location in locations.values():
            if location.name == vehicle_name:
                return location

        return None

    def get_vehicle_player_map(self) -> dict[int, list[Player]]:
        vehicle_to_player_map: dict[int, list[Player]] = {}
        for player in self.players.values():
            if (player.location and  # player has location
                    player.location.is_vehicle and  # assigned to vehicle
                    player.location.id in vehicle_to_player_map.keys()):

                vehicle_to_player_map[player.location.id].append(player)
            elif (player.location and  # player has location
                    player.location.is_vehicle):
                vehicle_to_player_map[player.location.id] = [player]
            else:
                logging.debug(f"Unable to map player {player.tan} to vehicle "
                              f"due to missing vehicle assignment.")
        return vehicle_to_player_map

    def archive(self):
        """
        Archives an execution by storing all associated events in a separate table
        and deactivating it.

        Note: If the same execution gets archived twice, the first version will be overwritten.
        """
        incomplete = self.status != Execution.Status.FINISHED

        with current_app.app_context():
            # Retrieve all associated events
            logged_events = map(lambda e: Event.from_logged_event(e).to_dict(),
                                db.session.query(models.LoggedEvent).filter_by(execution=self.id)
                                .order_by(models.LoggedEvent.time).all())
            # Create new archived execution
            archived_execution = models.ArchivedExecution(execution_id=self.id,
                                                          events=str(logged_events),
                                                          timestamp=utils.time.current_time_s(),
                                                          incomplete=incomplete)
            # Delete existing archived execution
            if db.session.query(models.ArchivedExecution).filter_by(execution_id=self.id).first():
                db.session.query(models.ArchivedExecution).filter_by(execution_id=self.id).delete()
            # Write new archived execution
            db.session.add(archived_execution)
            # Delete logged events (now stored in archive)
            if logged_events:
                db.session.query(models.LoggedEvent).filter_by(execution=self.id).delete()

            db.session.commit()
