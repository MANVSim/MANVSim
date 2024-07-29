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

    def to_dict(self, include: list | None = None,
                exclude: list | None = None) -> dict:
        """
        Returns all fields of this class in a dictionary. Via exclude and
        include, lists of attributes can be included or excluded from the
        result.
        """
        result = self.__dict__.copy()

        if include:
            result = {key: result[key] for key in include if key in result}
        if exclude:
            for key in exclude:
                result.pop(key, None)

        return result

    def to_json(self, include: list | None = None, exclude: list | None = None):
        """
        Returns this object as a JSON. Via exclude and include, lists of
        attributes can be included or excluded from the result.
        """
        return json.dumps(self.to_dict(include, exclude))
