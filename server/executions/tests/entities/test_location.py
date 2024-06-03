import threading
from time import sleep

from executions.entities.location import Location

flag = False


def test_timeout():
    def t2(loc):
        try:
            loc.add_locations()
        except TimeoutError:
            global flag
            flag = True
            print("Timeout caught.")

    global flag
    l = Location(1, "test", ".")
    l.loc_lock.acquire()  # t1

    threading.Thread(target=t2, args=([l])).start()
    sleep(4)  # trigger timeout
    assert flag

    # Cleanup
    l.loc_lock.release()
    flag = False
