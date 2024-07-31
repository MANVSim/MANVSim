import json

from execution.entities.action import Action
from execution.entities.resource import Resource


class PerformedAction:

    def __init__(self, id: str, time: int, execution_id: int, action: Action,
                 resources_used: list[Resource], player_tan: str):
        self.id = id  # UUID
        self.time = time  # Time, when action was finished
        self.execution_id = execution_id
        self.action = action
        self.resources_used = resources_used
        self.player_tan = player_tan

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
            'time': self.time,
            'execution_id': self.execution_id,
            'action': self.action.id if shallow else self.action.to_dict(),
            'resources_used': [resource.id if shallow else resource.to_dict()
                               for resource in self.resources_used],
            'player_tan': self.player_tan
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
