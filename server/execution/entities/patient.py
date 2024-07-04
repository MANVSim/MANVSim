import json
from enum import Enum

from execution.entities.location import Location
from execution.entities.performed_action import PerformedAction
from execution.entities.stategraphs.activity_diagram import ActivityDiagram
from execution.utils.timeoutlock import TimeoutLock
from models import Action
from vars import ACQUIRE_TIMEOUT


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

    def __init__(self, id: int, name: str, activity_diagram: ActivityDiagram, location: Location,
                 classification: Classification = Classification.NOT_CLASSIFIED,
                 performed_actions: list[PerformedAction] | None = None):

        if performed_actions is None:
            performed_actions = []

        self.id = id
        self.name = name
        self.activity_diagram = activity_diagram
        self.location = location
        self.classification = classification
        self.performed_actions = performed_actions

        self.action_queue = {}
        self.lock = TimeoutLock()

    # Suppresses "unexpected argument" warning for the lock.acquire_timeout() method. PyCharm does not recognize the
    # parameter in the related method definition.
    # noinspection PyArgumentList
    def apply_action(self, action: Action):
        """ Applies the provided action to the current active state. """
        with self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT):
            self.activity_diagram.apply_treatment(str(action.id))
            return action.results

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
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
