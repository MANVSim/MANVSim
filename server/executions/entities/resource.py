import json


class Resource:

    def __init__(self, id: int, name: str, quantity: int, picture_ref: str | None):
        self.id = id
        self.name = name
        self.quantity = quantity
        self.picture_ref = picture_ref

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'location': self.name,
            'quantity': self.quantity,
            'picture_ref': self.picture_ref
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
