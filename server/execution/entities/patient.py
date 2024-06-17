import json
from enum import Enum

from execution.entities.location import Location
from execution.entities.performed_action import PerformedAction


class Patient:

    class Classification(Enum):
        """
        Classifies the severity of injuries and need for a treatment according to the currently used metric in Germany.
        The prefix "PRE" indicates a preliminary classification that has to be verified by a doctor.
        """
        NOT_CLASSIFIED = "not classified"
        PRE_RED = "pre-classified red"
        RED = "red"
        PRE_YELLOW = "pre-classified yellow"
        YELLOW = "yellow"
        PRE_GREEN = "pre-classified green"
        GREEN = "green"
        PRE_BLUE = "pre-classified blue"
        BLUE = "blue"
        BLACK = "black"

    def __init__(self, id: int, name: str, injuries: str, activity_diagram: str, location: Location,
                 classification: Classification = Classification.NOT_CLASSIFIED,
                 performed_actions: list[PerformedAction] = None):

        if performed_actions is None:
            performed_actions = []

        self.id = id
        self.name = name
        self.injuries = injuries  # FIXME: Maybe replace by JSON datatype
        self.activity_diagram = activity_diagram  # FIXME: Maybe replace JSON datatype
        self.location = location
        self.classification = classification
        self.performed_actions = performed_actions

        self.action_queue = {}

    def apply_action(self, action):
        pass         # TODO implement impact on a patient status.

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'injuries': self.injuries,
            'activity_diagram': self.activity_diagram,
            'location': self.location.id if shallow else self.location.to_dict(),
            'classification': self.classification.name,
            'performed_actions': [performed_action.id if shallow else performed_action.to_dict() for performed_action in
                                  self.performed_actions]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
