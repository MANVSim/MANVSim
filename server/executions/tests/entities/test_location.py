from executions.entities.location import Location


def test_timeout():

    l = Location(1, "test", ".")
    l.loc_lock.acquire()  # t1
    try:
        l.add_locations(new_locations=set([]))
        assert False
    except TimeoutError:
        assert True

    # Cleanup
    l.loc_lock.release()
