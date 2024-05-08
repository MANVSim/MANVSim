class Location:

    def __init__(self, id: int, name: str, location: 'Location', picture_ref: str):
        self.id = id
        self.name = name
        self.location = location
        self.picture_ref = picture_ref  # Reference to picture
