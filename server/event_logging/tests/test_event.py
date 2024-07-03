from event_logging.event import Event


def test_factory_methods():
    assert Event.action_performed(
        1, 2, "player", 3, 4, 5).type == Event.Type.PERFORMED_ACTION

    assert Event.execution_started(1, 2).type == Event.Type.EXECUTION_STARTED

    assert Event.execution_finished(1, 2).type == Event.Type.EXECUTION_FINISHED
