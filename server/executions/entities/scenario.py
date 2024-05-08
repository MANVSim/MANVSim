from executions.entities.patient import Patient


class Scenario:

    def __init__(self, id: int, name: str, patients: list[Patient]):
        self.id = id
        self.name = name
        self.patients = patients
