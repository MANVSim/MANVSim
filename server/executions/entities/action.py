from resource_type import ResourceType


class Action:

    def __init__(self, id: int, name: str, result: str, picture: str, execution_time_sec: int,
                 resource_types_needed: list[ResourceType]):
        self.id = id
        self.name = name
        self.result = result  # FIXME: Maybe replace by JSON datatype
        self.picture = picture  # Reference to picture
        self.execution_time_sec = execution_time_sec  # FIXME: Maybe replace by standardized time format
        self.resource_types_needed = resource_types_needed
