from location import Location


class Patient:

    def __init__(self, id: int, injuries: str, activity_diagram: str,
                 location: Location):
        self.id = id
        self.injuries = injuries  # FIXME: Maybe replace by JSON datatype
        self.activity_diagram = activity_diagram  # FIXME: Maybe replace JSON datatype
        self.location = location
