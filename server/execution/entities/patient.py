import json
from enum import Enum
from typing import Optional

from execution.entities.action import Action
from execution.entities.location import Location
from execution.entities.performed_action import PerformedAction
from execution.entities.stategraphs.activity_diagram import ActivityDiagram
from execution.utils.timeoutlock import TimeoutLock
from media.media_data import MediaData
from vars import ACQUIRE_TIMEOUT


class Patient:

    class Classification(Enum):
        """
        Classifies the severity of injuries and need for a treatment according
        to the currently used metric in Germany. The prefix "PRE" indicates a
        preliminary classification that has to be verified by a doctor.
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

        @classmethod
        def from_string(cls, classification_name: str):
            """
            Converts a string to the corresponding classification object.
            """
            try:
                return cls[classification_name.upper()]
            except KeyError:
                raise ValueError(f"No classification found for name: "
                                 f"{classification_name}")

    def __init__(self, id: int, name: str, activity_diagram: ActivityDiagram,
                 location: Location, media_references: Optional[list[MediaData]] = None,
                 classification: Classification = Classification.NOT_CLASSIFIED,
                 performed_actions: dict[str, PerformedAction] | None = None):
        if performed_actions is None:
            performed_actions = {}
        if media_references is None:
            media_references = []

        self.id = id
        self.name = name
        self.activity_diagram = activity_diagram
        self.location = location
        self.media_references = media_references
        self.classification = classification
        self.performed_actions = performed_actions

        self.action_queue = {}
        self.lock = TimeoutLock()

    # Suppresses "unexpected argument" warning for the lock.acquire_timeout()
    # method. PyCharm does not recognize the parameter in the related method
    # definition.
    # noinspection PyArgumentList
    def apply_action(self, action: Action):
        """ Applies the provided action to the current active state. """
        with self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT):
            self.activity_diagram.apply_treatment(str(action.id))
            return action.results

    def start_activity_diagram(self):
        """ Starts the activity diagram. """
        self.activity_diagram.start_current_state()

    def pause_activity_diagram(self):
        """ Pauses the activity diagram. """
        self.activity_diagram.pause_current_state()

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
            'location': self.location.id if shallow else self.location.to_dict(),
            'media_references': [media_ref.to_dict() for media_ref in self.media_references],
            'classification': self.classification.name,
            'performed_actions': [
                performed_action.id if shallow else performed_action.to_dict()
                for performed_action in self.performed_actions.values()]
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
