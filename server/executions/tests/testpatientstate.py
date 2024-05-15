import time

from django.test import TestCase, Client

from executions.entities.stategraphs.patientstate import PatientState


class PatientStateTest(TestCase):

    def test_from_json(self):
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
        self.assertEqual(state.uuid, "628d6930-b667-4571-ad88-16f4857fed82")
        self.assertEqual(state.start_time, 42)
        self.assertEqual(state.timelimit, 1337)
        self.assertEqual(state.treatments["infusion"], "569f58d7-6cbb-4fde-97ae-f6b9f597c219")

        # Special Case: officially no attribute of PatientState but without any errors assigned as new variable.
        self.assertEqual(state.hello, "world")

    def test_to_json(self):
        timestamp = round(time.time())
        treatments = {
            "knive": "499d9080-dc68-41fc-a0a5-3f3e8563e70c",
            "infusion": "569f58d7-6cbb-4fde-97ae-f6b9f597c219"
        }
        state = PatientState(treatments=treatments, start_time=timestamp, timelimit=1337,
                             after_time_state_uuid="563b8b6a-11cb-40ad-bc62-6a833aebd024")
        state_dict = state.to_dict()
        self.assertEqual(state.uuid, state_dict["uuid"])
        self.assertEqual(state.start_time, state_dict["start_time"])
        self.assertEqual(state.timelimit, state_dict["timelimit"])
        self.assertEqual(state.after_time_state_uuid, state_dict["after_time_state_uuid"])
        print(f"DEBUG: JSON:\n{state.to_json()}")
