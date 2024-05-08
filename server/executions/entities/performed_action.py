from executions.entities.action import Action
from executions.entities.player import Player
from executions.entities.resource import Resource


class PerformedAction:

    def __init__(self, id: int, time: int, execution: str, action: Action,
                 resources_used: list[Resource], player: Player):
        self.id = id
        self.time = time  # FIXME: Maybe replace by standardized time format
        self.execution = execution  # TAN
        self.action = action
        self.resources_used = resources_used
        self.player = player
