import json

from executions.entities.action import Action
from executions.entities.location import Location
from executions.entities.patient import Patient


class Scenario:

    def __init__(self, id: int, name: str, patients: dict[int, Patient], actions: dict[int, Action],
                 locations: dict[int, Location]):
        self.id = id
        self.name = name
        self.patients = patients
        self.actions = actions
        self.locations = locations

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'patients': [patient.id if shallow else patient.to_dict() for patient in list(self.patients.values())],
            'actions': [action.id if shallow else action.to_dict() for action in list(self.actions.values())],
            'locations': [location.id if shallow else location.to_dict() for location in list(self.locations.values())]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
