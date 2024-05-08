from action import Action
from patient import Patient
from player import Player
from server.executions.entities.resource import Resource


class PerformedAction:

    def __init__(self, id: int, time: int, execution: str, patient: Patient, action: Action,
                 resources_used: list[Resource], player: Player):
        self.id = id
        self.time = time  # FIXME: Maybe replace by standardized time format
        self.execution = execution  # TAN
        self.patient = patient
        self.action = action
        self.resources_used = resources_used
        self.player = player
