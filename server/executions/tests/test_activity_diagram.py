import time

from django.test import TestCase

from executions.entities.stategraphs.activitydiagram import ActivityDiagram
from executions.entities.stategraphs.patientstate import PatientState


class ActivityDiagramTest(TestCase):

    def test_time_dash(self):
        timestamp = round(time.time())
        outdated_followup_uuid = "18a23a91-1f60-442a-b5c2-3a97b69e214d"
        update_uuid = "8c049d05-9dea-45f2-9ec1-7d2bb813569f"
        treatments = {
            "foo": "18a23a91-1f60-442a-b5c2-3a97b69e214d"
        }

        outdated_state = PatientState(start_time=timestamp-1000, treatments=treatments, timelimit=500,
                                      after_time_state_uuid=outdated_followup_uuid)
        outdated_followup_state = PatientState(state_uuid=outdated_followup_uuid, timelimit=1,
                                               after_time_state_uuid=update_uuid)
        updated_state_v1 = PatientState(state_uuid=update_uuid, timelimit=2000000)
        updated_state_v2 = PatientState(state_uuid=update_uuid)

        activity_diagram_v1 = ActivityDiagram(outdated_state,
                                              [outdated_state, outdated_followup_state, updated_state_v1])
        activity_diagram_v2 = ActivityDiagram(outdated_state,
                                              [outdated_state, outdated_followup_state, updated_state_v2])

        self.assertFalse(activity_diagram_v1.apply_treatment("foo"))
        self.assertFalse(activity_diagram_v2.apply_treatment("foo"))
        self.assertEqual(activity_diagram_v1.current.uuid, update_uuid)
        self.assertEqual(activity_diagram_v2.current.uuid, update_uuid)

    def test_to_dict(self):
        timestamp = round(time.time())
        treatments = {
            "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c",
            "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
        }
        state1 = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                              after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
        timestamp = round(time.time())
        state2 = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                              after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
        activity_diagram = ActivityDiagram(state1, [state2])
        activity_diagram_dict = activity_diagram.to_dict()
        self.assertEqual(activity_diagram.current.uuid, activity_diagram_dict["current"]["uuid"])

    def test_from_json(self):
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
        self.assertEqual(activity_diagram.states["54a8174a-d52a-4a76-84cb-d33fcdaf3b8f"].start_time, 1715753665)
        self.assertEqual(activity_diagram.current.after_time_state_uuid, "563b8b6a-11cb-40ad-bc62-6a833aebd024")
