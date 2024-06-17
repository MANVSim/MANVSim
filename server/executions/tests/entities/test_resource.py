import logging
import threading
import time

from executions.entities.resource import Resource
from utils import time as utime


def test_decrease(client):
    resource = Resource(id=1, name="test", quantity=10000, picture_ref="")

    # test infinite
    assert resource.decrease(duration=1)
    assert resource.quantity == 10000

    # test non-infinite
    old_quantity = 10
    resource.quantity = old_quantity
    assert resource.decrease(duration=1)
    assert resource.quantity == old_quantity - 1

    # test non-infinite non-consumable only single left
    resource.quantity = 1
    assert resource.decrease(duration=1)
    assert resource.locked_until != 0

    # test consumable empty
    resource.quantity = 0
    old_locked_until = resource.locked_until
    assert not resource.decrease(duration=1)
    assert resource.locked_until == old_locked_until

    # test non-consumable empty missing increase
    resource.consumable = False
    current_secs = utime.current_time_s()
    resource.locked_until = current_secs
    assert resource.decrease(duration=100)
    assert resource.locked_until > current_secs


def test_increase_decrease(client):
    quantity = 50
    resource = Resource(1, "test", quantity, "ref")
    resource.consumable = False

    def t2(r):
        for _ in range(50):
            r.increase(force=True)

    def t3(r):
        try:
            r.increase()
            logging.debug("unwanted increase performed.")
            raise AssertionError
        except TimeoutError:
            logging.debug("successful timeout.")

    resource.lock.acquire()
    threading.Thread(target=t2, args=([resource])).start()
    threading.Thread(target=t3, args=([resource])).start()
    for _ in range(50):
        resource.decrease(0)

    time.sleep(3.5)
    resource.lock.release()
    assert resource.quantity == quantity
