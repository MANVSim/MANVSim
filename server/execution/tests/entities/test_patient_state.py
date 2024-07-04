import logging

from execution.entities.stategraphs.patientstate import PatientState
from utils import time


def test_from_json():
    json_string = """{
                    "uuid": "628d6930-b667-4571-ad88-16f4857fed82",
                    "start_time": 42,
                    "timelimit": 1337,
                    "treatments": {
                        "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c", 
                        "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
                        }, 
                    "hello": "world"
                    }"""
    state: PatientState = PatientState().from_json(json_string)
    assert state.uuid == "628d6930-b667-4571-ad88-16f4857fed82"
    assert state.start_time == 42
    assert state.timelimit == 1337
    assert state.treatments["infusion"] == "569f58d7-6cbb-4fde-97ae-f6b9f597c219"

    # Special Case: officially no attribute of PatientState but without any errors assigned as new variable.
    assert state.hello == "world"  # type: ignore


def test_to_json():
    timestamp = time.current_time_s()
    treatments = {
        "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c",
        "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
    }
    state = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                         after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
    state_dict = state.to_dict()
    assert state.uuid == state_dict["uuid"]
    assert state.start_time == state_dict["start_time"]
    assert state.timelimit == state_dict["timelimit"]
    assert state.after_time_state_uuid == state_dict["after_time_state_uuid"]
    logging.debug(f"JSON:\n{state.to_json()}")
