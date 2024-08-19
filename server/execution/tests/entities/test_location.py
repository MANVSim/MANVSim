from execution import run
from execution.entities.location import Location


def test_timeout():
    l = Location(1, "test", [])
    l.loc_lock.acquire()  # t1
    try:
        l.add_locations(new_locations=set([]))
        assert False
    except TimeoutError:
        assert True

    # Cleanup
    l.loc_lock.release()


def test_leave_location(client):
    # Setup
    execution = run.active_executions[2]
    locations = list(execution.scenario.locations.values())
    location_parent = locations[0]
    # "Blauer Rucksack"
    location_rm: Location = location_parent.get_location_by_id(3) # type: ignore

    resources_rm = location_rm.resources
    remove = {location_rm}

    # Test 1: blocked resource
    assert resources_rm[0].lock.acquire()
    assert not location_parent.leave_location(removed=remove)
    resources_rm[0].lock.release()

    # Test 2: blocked location due to other leave
    assert location_rm.res_lock.acquire()
    assert not location_parent.leave_location(removed=remove)
    assert not location_rm.loc_lock.locked()
    location_rm.res_lock.release()

    # Test 3: blocked location due to other leave
    assert location_rm.loc_lock.acquire()
    assert not location_parent.leave_location(removed=remove)
    assert not location_rm.res_lock.locked()
    location_rm.loc_lock.release()

    # Test 4: no resource to be removed
    assert location_parent.leave_location(removed=set([]))

    # Test 5: remove resource
    assert location_parent.leave_location(removed=remove)
    l, r = location_parent.get_resource_by_id(resources_rm[0].id)  # try to find a resource on location.
    assert l is None and r is None
