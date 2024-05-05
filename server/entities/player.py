from execution import Execution
from location import Location


class Player:

    def __init__(self, tan: str, name: str, execution: Execution, location: Location):
        self.tan = tan
        self.name = name
        self.execution = execution
        self.location = location
