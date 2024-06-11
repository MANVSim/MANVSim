import threading
from time import sleep

from executions import run
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


def test_leave_location(client):

    execution = run.exec_dict["2"]
    locations = list(execution.scenario.locations.values())
    location_parent = locations[0]
    location_rm1: Location = locations[2]
    resources_rm1 = location_rm1.resources
    remove = {location_rm1}
    resources_rm1[0].lock.acquire()

    assert not location_parent.leave_location(removed=remove)



