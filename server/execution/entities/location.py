import json
from queue import Queue

from execution.entities.resource import Resource, try_lock_all, \
    release_all_resources
from execution.utils.timeoutlock import TimeoutLock
from media.media_data import MediaData
from vars import ACQUIRE_TIMEOUT


# Suppresses "unexpected argument" warning for the lock.acquire_timeout()
# method. PyCharm does not recognize the parameter in the related method
# definition.
# noinspection PyArgumentList
class Location:

    def __init__(self, id: int, name: str, media_references: list[MediaData],
                 resources: list[Resource] | None = None,
                 sub_locations: set['Location'] | None = None,
                 is_vehicle: bool = False):
        if resources is None:
            resources = []
        if sub_locations is None:
            sub_locations = set()

        self.id = id
        self.name = name
        self.media_references = media_references
        self.resources = resources

        # type 'set', because inventory can be managed by union and - operations
        self.sub_locations = sub_locations

        self.is_vehicle = is_vehicle
        self.available = not self.is_vehicle

        self.res_lock = TimeoutLock()
        self.loc_lock = TimeoutLock()

    def __repr__(self):
        return (
            f"Location(id={self.id!r}, name={self.name!r}, \
            media_references={self.media_references!r}, \
            resources={self.resources!r}, \
            locations={self.sub_locations!r}, \
            is_vehicle={self.is_vehicle!r})"
        )

    def get_location_by_id(self, location_id: int):
        """
        Retrieves a location of the stored toplevel sub-locations.
        If the list is blocked more than 3 seconds the methods raises a
        TimeoutError.
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                return next((location for location in self.sub_locations if
                             location.id == location_id), None)
            else:
                raise TimeoutError

    def remove_location_by_id(self, location_id: int):
        """
        Removes a location of the stored locations. If the list is blocked more
        than 3 seconds the methods raises a TimeoutError
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = {location for location in
                                      self.sub_locations if
                                      location.id != location_id}
            else:
                raise TimeoutError

    def add_locations(self, new_locations: set):
        """
        Unions a location-set of the stored locations. If the list is blocked
        more than 3 seconds the methods raises a TimeoutError.
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = self.sub_locations.union(new_locations)
            else:
                raise TimeoutError

    def remove_locations(self, old_locations: set):
        """
        Removes a set of locations of the stored locations. If the list is
        blocked more than 3 seconds the methods raises a TimeoutError.
        """
        with self.loc_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.sub_locations = self.sub_locations - old_locations
            else:
                raise TimeoutError

    def add_resources(self, new_resources: list):
        """
        Adds a resource to the resource list. If the list is blocked more than
        3 seconds the methods raises a TimeoutError.
        """
        with self.res_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.resources += new_resources
            else:
                raise TimeoutError

    def remove_resources(self, old_resources: list):
        """
        Removes a resource list of the stored resource-list. If the list is
        blocked more than 3 seconds the methods raises a TimeoutError.
        """
        with self.res_lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if acquired:
                self.resources = [resource for resource in self.resources if
                                  resource not in old_resources]
            else:
                raise TimeoutError

    def get_child_location_by_id(self, id):
        """
        Retrieves an "unknown" location of the locations array. "Unknown" means
        the requested location might be located in a lower level. If the list is
        blocked more than 3 seconds the methods raises a TimeoutError.
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
        Retrieves a resource out of the location tree. If the resource is
        available it returns the instance, None otherwise.
        """
        # resource is contained on the current location
        for res in self.resources:
            if res.id == id:
                return self, res

        # resource is contained in another location
        for loc in self.sub_locations:
            found_loc, res = loc.get_resource_by_id(id)
            if res is not None:
                return found_loc, res

        return None, None

    def leave_location(self, removed: set):
        """
        Removes provided location set from the location list. It raises a
        TimeoutError, if the related lock is not accessible.
        """
        q = Queue()  # for all reachable nodes (locations)
        locking_q = Queue()  # for all nodes contained in removed

        loc_locked = []  # backup list for lock rollback
        identified_nodes = 0  # counter to break search iff all nodes were identified

        # identify removing nodes (locations)
        q.put(self)
        while not q.empty():
            loc = q.get()
            if loc in removed:
                identified_nodes += 1
                locking_q.put(loc)
            else:
                _add_locations_to_queue(q, loc)

            if identified_nodes == len(removed):
                break

        # lock all resources related to the leaving action
        success = True
        while not locking_q.empty():
            loc = locking_q.get()
            # mark location for a leave
            if loc.loc_lock.acquire(timeout=ACQUIRE_TIMEOUT):
                if loc.res_lock.acquire(timeout=ACQUIRE_TIMEOUT):

                    # block resource for editing
                    if try_lock_all(loc.resources):
                        loc_locked.append(loc)
                        _add_locations_to_queue(locking_q, loc)
                        continue  # locking whole location with its resources successful
                    else:
                        success = False
                        loc.loc_lock.release()
                        loc.res_lock.release()
                        break

                if loc.loc_lock.locked():
                    # res_lock acquire failed but loc_lock was successful
                    loc.loc_lock.release()

            success = False
            break

        if success:
            self.sub_locations -= removed  # reduce location access according to provided set

        release_all_locations(locations=loc_locked, include_resource=True)
        return success

    def to_dict(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns all fields of this class in a dictionary. By default, all nested
        objects are included. In case the 'shallow'-flag is set, only the object
        reference in form of a unique identifier is included. Via exclude and
        include, lists of attributes can be included or excluded from the
        result.
        """
        result = {
            'id': self.id,
            'name': self.name,
            'is_vehicle': self.is_vehicle,
            'media_references': [media_ref.to_dict() for media_ref in
                                 self.media_references],
            'resources': [resource.id if shallow else resource.to_dict() for
                          resource in self.resources],
            'sub_locations': [location.id if shallow else location.to_dict() for
                              location in self.sub_locations]
        }

        if include:
            result = {key: result[key] for key in include if key in result}
        if exclude:
            for key in exclude:
                result.pop(key, None)

        return result

    def to_json(self, shallow: bool = False, include: list | None = None,
                exclude: list | None = None):
        """
        Returns this object as a JSON. By default, all nested objects are
        included. In case the 'shallow'-flag is set, only the object reference
        in form of a unique identifier is included. Via exclude and
        included, lists of attributes can be included or excluded from the
        result.
        """
        return json.dumps(self.to_dict(shallow, include, exclude))


def release_all_locations(locations: list['Location'], include_resource=False):
    for loc in locations:
        if include_resource:
            release_all_resources(loc.resources)

        if loc.res_lock.locked():
            loc.res_lock.release()

        if loc.loc_lock.locked():
            loc.loc_lock.release()


def _add_locations_to_queue(queue: Queue, location: 'Location'):
    for child_loc in location.sub_locations:
        queue.put(child_loc)
