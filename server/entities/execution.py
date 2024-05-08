from enum import Enum

from player import Player
from scenario import Scenario


class Execution:

    class Status(Enum):
        RUNNING = "running"
        WAITING = "pending"
        STOPPED = "finished"
        UNKNOWN = "unknown"

    def __init__(self, id: int, scenario: Scenario, starting_time: int, players: list[Player], status: Status):
        self.id = id  # FIXME: Maybe replace by TAN
        self.scenario = scenario
        self.starting_time = starting_time  # FIXME: Maybe replace by standardized time format
        self.players = players
        self.status = status

