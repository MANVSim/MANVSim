import json
from functools import total_ordering


@total_ordering
class Role:

    def __init__(self, id: int, name: str, short_name: str | None, power: int):
        self.id = id
        self.name = name
        self.short_name = short_name
        self.power = power

    def __lt__(self, other: 'Role'):
        return self.power < other.power

    def __eq__(self, other):
        return self.power == other.power

    def __repr__(self):
        return (
            f"Role(id={self.id!r}, \
            name={self.name!r}, \
            short_name={self.short_name!r}, \
            power={self.power!r})"
        )

    def to_dict(self) -> dict:
        return self.__dict__

    def to_json(self):
        return json.dumps(self.to_dict())
