import json

from execution.entities.action import Action
from execution.entities.location import Location
from execution.entities.patient import Patient


class Scenario:

    def __init__(self, s_id: int, name: str, patients: dict[int, Patient],
                 actions: dict[int, Action], locations: dict[int, Location]):
        self.id = s_id
        self.name = name
        self.patients = patients
        self.actions = actions
        self.locations = locations

    def run_patients(self):
        for patient in self.patients.values():
            patient.start_activity_diagram()

    def pause_patients(self):
        for patient in self.patients.values():
            patient.pause_activity_diagram()

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
            'patients': [patient.id if shallow else patient.to_dict() for
                         patient in list(self.patients.values())],
            'actions': [action.id if shallow else action.to_dict() for action in
                        list(self.actions.values())],
            'locations': [location.id if shallow else location.to_dict() for
                          location in list(self.locations.values())]
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
        in form of a unique identifier is included. Via exclude and include,
        lists of attributes can be included or excluded from the result.
        """
        return json.dumps(self.to_dict(shallow, include, exclude))
