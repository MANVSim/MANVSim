import json
from enum import Enum
from app_config import db

from models import LoggedEvent

class Event:

    class Type(Enum):
        PERFORMED_ACTION = "performed_action"
        EXECUTION_STARTED = "execution_started"
        EXECUTION_FINISHED = "execution_finished"

    def __init__(self, execution: int, type: Type, time: int, data):
        self.execution = execution
        self.type = type
        self.time = time
        self.data = data

    @staticmethod
    def execution_started(execution_id: int, time: int):
        return Event(execution_id, Event.Type.EXECUTION_STARTED, time, {})

    @staticmethod
    def execution_finished(execution_id: int, time: int):
        return Event(execution_id, Event.Type.EXECUTION_FINISHED, time, {})

    @staticmethod
    def action_performed(execution_id: int, time: int, player: str, action: int, patient: int, duration_s: int):
        return Event(execution_id, Event.Type.PERFORMED_ACTION, time, {
            "action": action,
            "player": player,
            "patient": patient,
            "duration_s": duration_s
        })

    def to_dict(self):
        return {
            "execution": self.execution,
            "time": self.time,
            "type": self.type.name,
            "data": self.data
        }

    def to_json(self):
        return json.dumps(self.to_dict())

    @staticmethod
    def from_logged_event(logged_event: LoggedEvent):
        return Event(logged_event.execution, Event.Type[logged_event.type], logged_event.time, logged_event.data)

    @staticmethod
    def from_json(json_str: str):
        data = json.loads(json_str)
        return Event(data["execution"], Event.Type[data["type"]], data["time"], data["data"])

    def log(self):
        evt = LoggedEvent(execution=self.execution, type=self.type.name, time=self.time, data=self.data)
        db.session.add(evt)
        db.session.commit()
        pass
