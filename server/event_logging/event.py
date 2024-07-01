import json
from enum import Enum
from app_config import db

from models import LoggedEvent


class Event:
    """
    Represents an event relevant during an execution of the simulation.
    This includes events like the start and end of an execution, as well as actions performed by players.
    """

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
        """
        Creates an event representing the start of an execution.
        """
        return Event(execution=execution_id, type=Event.Type.EXECUTION_STARTED, time=time, data={})

    @staticmethod
    def execution_finished(execution_id: int, time: int):
        """
        Creates an event representing the end of an execution.
        """
        return Event(execution=execution_id, type=Event.Type.EXECUTION_FINISHED, time=time, data={})

    @staticmethod
    def action_performed(execution_id: int, time: int, player: str, action: int, patient: int, duration_s: int):
        """
        Creates an event representing an action performed by a player.
        """
        return Event(execution=execution_id, type=Event.Type.PERFORMED_ACTION, time=time, data={
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
        return Event(execution=logged_event.execution, type=Event.Type[logged_event.type], time=logged_event.time, data=logged_event.data)

    @staticmethod
    def from_json(json_str: str):
        data = json.loads(json_str)
        return Event(execution=data["execution"], type=Event.Type[data["type"]], time=data["time"], data=data["data"])

    def log(self):
        evt = LoggedEvent(execution=self.execution,
                          type=self.type.name, time=self.time, data=self.data)  # type: ignore
        db.session.add(evt)
        db.session.commit()
