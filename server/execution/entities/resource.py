import json

from execution.utils.timeoutlock import TimeoutLock
from media.media_data import MediaData
from utils import time
from vars import ACQUIRE_TIMEOUT


class Resource:

    def __init__(self, id: int, name: str, quantity: int,
                 media_references: list[MediaData], consumable: bool = True):
        self.id = id
        self.name = name
        self.quantity = quantity  # quantity >= 10000 indicates infinite resource
        self.media_references = media_references

        self.consumable = consumable
        self.lock = TimeoutLock()
        self.locked_until = 0

    def __repr__(self):
        return (
            f"Resource(id={self.id!r}, \
            name={self.name!r}, \
            quantity={self.quantity!r}, \
            media_references={self.media_references!r}, \
            consumable={self.consumable!r}, \
            locked_until={self.locked_until!r})"
        )

    def decrease(self, duration):
        """
        Decreases the quantity of the resource. If the quantity equals zero and
        is marked as 'non-consumable' additionally the locked-flag is set, when
        the resource is accessible again. If the locked-flag is outdated the
        method reassigns the flag and simulates an increase&decrease-operation.
        CAUTION: only use decrease if the resource is blocked beforehand.

         - duration: amount of time the resource might be blocked
        """
        current_secs = time.current_time_s()
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

    # Suppresses "unexpected argument" warning for the lock.acquire_timeout()
    # method. PyCharm does not recognize the parameter in the related method
    # definition.
    # noinspection PyArgumentList
    def increase(self, force=False):
        """
        Increases the quantity, in case the resource is a non-consumable. Using
        the force parameter, allows (consumable) resources to increase the
        quantity without locking, for rollback reasons.
        """
        if force:
            self.quantity += 1
            return

        with (self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT)) as acquired:
            if acquired:
                # resources can only be restored if they are non consumables and
                # no other resource has claimed the resource in the meantime.
                if not self.consumable and time.current_time_s() > self.locked_until:
                    self.quantity += 1
            else:
                raise TimeoutError

    def to_dict(self):
        """
        Returns all fields of this class in a dictionary. By default, all nested
        objects are included. In case the 'shallow'-flag is set, only the object
        reference in form of a unique identifier is included.
        """
        return {
            'id': self.id,
            'name': self.name,
            'quantity': self.quantity,
            'media_references': [media_ref.to_dict() for media_ref in
                                 self.media_references],
        }

    def to_json(self):
        """
        Returns this object as a JSON. By default, all nested objects are
        included. In case the 'shallow'-flag is set, only the object reference
        in form of a unique identifier is included.
        """
        return json.dumps(self.to_dict())


def try_lock_all(resources: list['Resource']):
    """
    Tries to lock all provided resources. If not successful, every lock will be
    released. Returns a boolean in every case.
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


def release_all_resources(resources: list['Resource']):
    """ Releases all locks of the resources provided. """
    for res in resources:
        res.lock.release()
