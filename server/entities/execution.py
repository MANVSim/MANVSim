from player import Player
from scenario import Scenario


class Execution:

    def __init__(self, id: int, scenario: Scenario, starting_time: int, players: list[Player]):
        self.id = id  # FIXME: Maybe replace by TAN
        self.scenario = scenario
        self.starting_time = starting_time  # FIXME: Maybe replace by standardized time format
        self.players = players
