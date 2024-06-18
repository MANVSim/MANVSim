import json
from queue import Queue

from execution.entities.resource import Resource
from execution.utils.timeoutlock import TimeoutLock
from vars import ACQUIRE_TIMEOUT


# Suppresses "unexpected argument" warning for the lock.acquire_timeout() method. PyCharm does not recognize the
# parameter in the related method definition.
# noinspection PyArgumentList
class Location:

    def __init__(self, id: int, name: str, picture_ref: str | None, resources: list[Resource] = None,
                 sub_locations: set['Location'] = None):
        if resources is None:
            resources = []
        if sub_locations is None:
            sub_locations = set()

        self.id = id
        self.name = name
        self.picture_ref = picture_ref  # Reference to picture
        self.resources = resources
        self.sub_locations = sub_locations

        self.res_lock = TimeoutLock()
        self.loc_lock = TimeoutLock()

    def __repr__(self):
        return (f"Location(id={self.id!r}, name={self.name!r}, picture_ref={self.picture_ref!r}, "
                f"resources={self.resources!r}, locations={self.sub_locations!r})")

    def get_location_by_id(self, id):
        """
        Retrieves a location of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                return next((location for location in self.sub_locations if location.id == id), None)
            else:
                raise TimeoutError

    def remove_location_by_id(self, id):
        """
        Removes a location of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = {location for location in self.sub_locations if location.id != id}
            else:
                raise TimeoutError

    def add_locations(self, new_locations: set):
        """
        Unions a location-set of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = self.sub_locations.union(new_locations)
            else:
                raise TimeoutError

    def remove_locations(self, old_locations: set):
        """
        Removes a set of locations of the stored locations.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = self.sub_locations - old_locations
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
                self.sub_locations = [resource for resource in self.resources if resource not in old_resources]
            else:
                raise TimeoutError

    def get_child_location_by_id(self, id):
        """
        Retrieves an "unknown" location of the locations array. "Unknown" means the requested location might be
        located in a lower level.
        If the list is blocked more than 3 seconds the methods raises a TimeoutError
        """
        q = Queue()
        for loc in list(self.sub_locations):
            q.put((self, loc))

        while q.not_empty:
            parent, child = q.get()
            if child.id == id:
                return parent, child
            else:
                for child_loc in list(self.sub_locations):
                    q.put((child, child_loc))

        return None, None

    def get_resource_by_id(self, id):
        """
        Retrieves a resource out of the location tree. If the resource is available it returns the instance,
        None otherwise.
        """
        # resource is contained on the current location
        for res in self.resources:
            if res.id == id:
                return res

        # resource is contained in another location
        for loc in self.sub_locations:
            res = loc.get_resource_by_id(id)
            if res is not None:
                return res

        return None

    def leave_location(self, removed: set):
        """
        Removes provided location set from the location list. It raises a TimeoutError, if the related lock is not
        accessible.
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations -= removed
            else:
                raise TimeoutError

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
            'sub_locations': [location.id if shallow else location.to_dict() for location in self.sub_locations]
        }

    def to_json(self, shallow: bool = False):
        """
        Returns this object as a JSON. By default, all nested objects are included. In case the 'shallow'-flag is set,
        only the object reference in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict(shallow))
