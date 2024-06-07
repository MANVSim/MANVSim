import json
from queue import Queue

from executions.entities.resource import Resource
from executions.utils.timeoutlock import TimeoutLock
from vars import ACQUIRE_TIMEOUT


# Suppresses "unexpected argument" warning for the lock.acquire_timeout() method. PyCharm does not recognize the
# parameter in the related method definition.
# noinspection PyArgumentList
class Location:

    def __init__(self, id: int, name: str, picture_ref: str | None, resources: list[Resource] = None,
                 locations: set['Location'] = None):
        if resources is None:
            resources = []
        if locations is None:
            locations = set()

        self.id = id
        self.name = name
        self.picture_ref = picture_ref  # Reference to picture
        self.resources = resources
        self.locations = locations

        self.res_lock = TimeoutLock()
        self.loc_lock = TimeoutLock()

    def get_location_by_id(self, id):
        """
        Retrieves a location of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                return next((location for location in self.locations if location.id == id), None)
            else:
                raise TimeoutError

    def remove_location_by_id(self, id):
        """
        Removes a location of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.locations = {location for location in self.locations if location.id != id}
            else:
                raise TimeoutError

    def add_locations(self, new_locations: set):
        """
        Unions a location-set of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.locations.union(new_locations)
            else:
                raise TimeoutError

    def remove_locations(self, old_locations: set):
        """
        Removes a set of locations of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.locations = self.locations - old_locations
            else:
                raise TimeoutError

    def add_resources(self, new_resources: list):
        """
        Adds a resource to the resource list.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.res_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.resources += new_resources
            else:
                raise TimeoutError

    def remove_resources(self, old_resources: list):
        """
        Removes a resource list of the stored resource-list.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.res_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.locations = [resource for resource in self.resources if resource not in old_resources]
            else:
                raise TimeoutError

    def get_child_location_by_id(self, id):
        """
        Retrieves an "unknown" location of the locations array. "Unknown" means the requested location might be
        located in a lower level.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        q = Queue()
        for loc in list(self.locations):
            q.put((self, loc))

        while q.not_empty:
            parent, child = q.get()
            if child.id == id:
                return parent, child
            else:
                for child_loc in list(self.locations):
                    q.put((child, child_loc))

        return None, None

    def to_dict(self, shallow: bool = False):
        """
        Returns all fields of this class in a dictionary. By default, all nested objects are included. In case the
        'shallow'-flag is set, only the object reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'picture_ref': self.picture_ref,
            'resources': [resource.id if shallow else resource.to_dict() for resource in self.resources],
            'location': [location.id if shallow else location.to_dict() for location in self.locations]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
