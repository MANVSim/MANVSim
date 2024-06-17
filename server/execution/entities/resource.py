import json

from executions.utils import util
from executions.utils.timeoutlock import TimeoutLock
from vars import ACQUIRE_TIMEOUT


# noinspection PyArgumentList
class Resource:

    def __init__(self, id: int, name: str, quantity: int, picture_ref: str):
        self.id = id
        self.name = name
        self.quantity = quantity  # quantity >= 10000 indicates infinite resource
        self.picture_ref = picture_ref

        self.consumable = True
        self.lock = TimeoutLock()
        self.locked_until = 0

    def decrease(self, duration):
        """
        Decreases the quantity of the resource. If the quantity equals zero and is marked as 'non-consumable'
        additionally the locked-flag is set, when the resource is accessible again. If the locked-flag is outdated the
        method reassigns the flag and simulates an increase&decrease-operation.
        CAUTION: only use decrease if the resource is blocked beforehand.

         - duration: amount of time the resource might be blocked
        """
        current_secs = util.get_current_secs()
        if self.quantity >= 10000:
            return True  # resource is infinite
        elif self.quantity > 0:
            # resource is available
            self.quantity -= 1
            self.locked_until = current_secs + duration if self.quantity == 0 else self.locked_until
            return True
        elif self.consumable:
            # empty consumable
            return False
        elif self.locked_until > current_secs:
            # resource is not available and will be restored
            return False
        else:
            # resource is not available but should have been restocked by now
            self.locked_until = current_secs + duration
            return True

    def increase(self, force=False):
        """
        Increases the quantity, in case the resource is a non-consumable. Using the force parameter, allows
        (consumable) resources to increase the quantity without locking, for rollback reasons.
        """
        if force:
            self.quantity += 1
            return

        with (self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT)) as acquired:
            if acquired:
                # resources can only be restored if they are non consumables and no other resource has claimed the
                # resource in the meantime.
                if not self.consumable and util.get_current_secs() > self.locked_until:
                    self.quantity += 1
            else:
                raise TimeoutError

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
    resources = sorted(resources, key=lambda resource: resource.id)
    success = True
    blocked_resources = []
    for res in resources:
        if not res.lock.acquire(timeout=0.5):
            success = False
            break
        else:
            blocked_resources.append(res)
    if not success:
        [r.lock.release() for r in blocked_resources]

    return success


def release_all(resources: list['Resource']):
    """ Releases all locks of the resources provided. """
    for res in resources:
        res.lock.release()
