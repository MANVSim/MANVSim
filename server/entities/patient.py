from performed_action import PerformedAction


class Patient:

    def __init__(self, id: int, injuries: str, activity_diagram: str, performed_actions: list[PerformedAction]):
        self.id = id
        self.injuries = injuries  # FIXME: Maybe replace by JSON datatype
        self.activity_diagram = activity_diagram  # FIXME: Maybe replace JSON datatype
        self.performed_actions = performed_actions
