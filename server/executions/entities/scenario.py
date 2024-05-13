import json

from executions.entities.patient import Patient


class Scenario:

    def __init__(self, id: int, name: str, patients: list[Patient]):
        self.id = id
        self.name = name
        self.patients = patients

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'patients': [patient.id if shallow else patient.to_dict() for patient in self.patients]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
