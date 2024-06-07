import json

from executions.utils.timeoutlock import TimeoutLock


class Resource:

    def __init__(self, id: int, name: str, quantity: int, picture_ref: str):
        self.id = id
        self.name = name
        self.quantity = quantity
        self.picture_ref = picture_ref

        self.consumable = True
        self.lock = TimeoutLock()

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


def try_lock_all(resources: list['Resource']):
    """
    Tries to lock all provided resources. If not successful, every lock will be released. Returns a boolean in every
    case.
    """
    success = True
    blocked_resources = []
    for res in resources:
        if not res.lock.acquire(blocking=False):
            success = False
            break
        else:
            blocked_resources.append(res)
    if not success:
        [r.lock.release() for r in blocked_resources]

    return success
