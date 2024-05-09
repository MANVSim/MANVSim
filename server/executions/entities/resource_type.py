import json


class ResourceType:

    def __init__(self, id: int, name: str, picture_ref: str):
        self.id = id
        self.name = name
        self.picture_ref = picture_ref  # Reference to picture

    def to_dict(self):
        return self.__dict__

    def to_json(self):
        return json.dumps(self.__dict__)
