from executions.entities.location import Location
from executions.entities.performed_action import PerformedAction


class Patient:

    def __init__(self, id: int, name: str, injuries: str, activity_diagram: str,
                 location: Location, performed_actions: list[PerformedAction]):
        self.id = id
        self.name = name
        self.injuries = injuries  # FIXME: Maybe replace by JSON datatype
        self.activity_diagram = activity_diagram  # FIXME: Maybe replace JSON datatype
        self.location = location
        self.performed_actions = performed_actions
