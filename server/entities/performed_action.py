from action import Action
from patient import Patient
from resource import Resource


class PerformedAction:

    def __init__(self, id: int, time: int, execution: str, patient: Patient, action: Action,
                 resources_used: list[Resource]):
        self.id = id
        self.time = time  # FIXME: Maybe replace by standardized time format
        self.execution = execution  # TAN
        self.patient = patient
        self.action = action
        self.resources_used = resources_used
