import json

from executions.entities.action import Action
from executions.entities.resource import Resource


class PerformedAction:

    def __init__(self, id: str, time: int, execution_id: str, action: Action, resources_used: list[Resource],
                 player_tan: str):
        self.id = id  # uuid
        self.time = time
        self.execution_id = execution_id  # TAN
        self.action = action
        self.resources_used = resources_used
        self.player_tan = player_tan

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'time': self.time,
            'execution_id': self.execution_id,
            'action': self.action.id if shallow else self.action.to_dict(),
            'resources_used': [resource.id if shallow else resource.to_dict() for resource in self.resources_used],
            'player_tan': self.player_tan
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
