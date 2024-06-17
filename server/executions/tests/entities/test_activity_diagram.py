from executions.entities.stategraphs.activity_diagram import ActivityDiagram
from executions.entities.stategraphs.patientstate import PatientState
from utils import time


def test_time_dash():
    timestamp = time.current_time_s()
    outdated_followup_uuid = "18a23a91-1f60-442a-b5c2-3a97b69e214d"
    update_uuid = "8c049d05-9dea-45f2-9ec1-7d2bb813569f"
    treatments = {
        "foo": "18a23a91-1f60-442a-b5c2-3a97b69e214d"
    }

    outdated_state = PatientState(start_time=timestamp - 1000, treatments=treatments, timelimit=500,
                                  after_time_state_uuid=outdated_followup_uuid)
    outdated_followup_state = PatientState(state_uuid=outdated_followup_uuid, timelimit=1,
                                           after_time_state_uuid=update_uuid)
    updated_state_v1 = PatientState(state_uuid=update_uuid, timelimit=2000000)
    updated_state_v2 = PatientState(state_uuid=update_uuid)

    activity_diagram_v1 = ActivityDiagram(outdated_state,
                                          [outdated_state, outdated_followup_state, updated_state_v1])
    activity_diagram_v2 = ActivityDiagram(outdated_state,
                                          [outdated_state, outdated_followup_state, updated_state_v2])

    assert not activity_diagram_v1.apply_treatment("foo")
    assert not activity_diagram_v2.apply_treatment("foo")
    assert activity_diagram_v1.current.uuid == update_uuid
    assert activity_diagram_v2.current.uuid == update_uuid


def test_to_dict():
    timestamp = time.current_time_s()
    treatments = {
        "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c",
        "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
    }
    state1 = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                          after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
    timestamp = time.current_time_s()
    state2 = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                          after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
    activity_diagram = ActivityDiagram(state1, [state2])
    activity_diagram_dict = activity_diagram.to_dict()
    assert activity_diagram.current.uuid == activity_diagram_dict["current"]["uuid"]


def test_from_json():
    json_string = """{
    "states": {"54a8174a-d52a-4a76-84cb-d33fcdaf3b8f": {
                         "uuid": "54a8174a-d52a-4a76-84cb-d33fcdaf3b8f", 
                         "start_time": 1715753665, 
                         "timelimit": 1337, 
                         "after_time_state_uuid": "563b8b6a-11cb-40ad-bc62-6a833aebd024", 
                         "treatments": {
                            "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c", 
                            "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
                            }
                        }
                },
   "current": {
        "uuid": "54a8174a-d52a-4a76-84cb-d33fcdaf3b8f", 
        "start_time": 1715753665, 
        "timelimit": 1337, 
        "after_time_state_uuid": "563b8b6a-11cb-40ad-bc62-6a833aebd024", 
        "treatments": {
            "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c", 
            "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
            }
        }   
    }"""
    activity_diagram = ActivityDiagram().from_json(json_string=json_string)
    assert activity_diagram.states["54a8174a-d52a-4a76-84cb-d33fcdaf3b8f"].start_time == 1715753665
    assert activity_diagram.current.after_time_state_uuid == "563b8b6a-11cb-40ad-bc62-6a833aebd024"
