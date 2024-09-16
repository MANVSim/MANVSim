import json
from enum import Enum
from typing import Optional

import utils.time
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
        EXECUTION_PAUSED = "execution_paused"
        EXECUTION_FINISHED = "execution_finished"
        LOCATION_TAKE_FROM = "location_take_from"
        PATIENT_ARRIVE = "patient_arrive"
        PATIENT_CLASSIFY = "patient_classify"
        LOCATION_LEAVE = "location_leave"
        PLAYER_ALERTED = "player_alerted"

    def __init__(self, execution: int, type: Type, time: int, data):
        self.execution = execution
        self.type = type
        self.time = time
        self.data = data

    @staticmethod
    def execution_started(ex_id: int, ex_data: str, time: Optional[int] = None):
        """
        Creates an event representing the start of an execution.
        """
        if not time:
            time = utils.time.current_time_s()
        return Event(execution=ex_id, type=Event.Type.EXECUTION_STARTED, time=time, data=ex_data)

    @staticmethod
    def execution_paused(ex_id: int, time: Optional[int] = None):
        """
        Creates an event representing the start of an execution.
        """
        if not time:
            time = utils.time.current_time_s()
        return Event(execution=ex_id, type=Event.Type.EXECUTION_PAUSED, time=time, data={})

    @staticmethod
    def execution_finished(ex_id: int, ex_data: str, time: Optional[int] = None):
        """
        Creates an event representing the end of an execution.
        """
        if not time:
            time = utils.time.current_time_s()
        return Event(execution=ex_id, type=Event.Type.EXECUTION_FINISHED, time=time, data=ex_data)

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

    @staticmethod
    def location_take_from(execution_id: int, time: int, player: str, take_location_ids: list[int], to_location_ids: list[int]):
        """
        Creates an event representing the action of taking a location from another location.
        """
        return Event(execution=execution_id, type=Event.Type.LOCATION_TAKE_FROM, time=time, data={
            "player": player,
            "take_location_ids": take_location_ids,
            "to_location_ids": to_location_ids
        })

    @staticmethod
    def location_put_to(execution_id: int, time: int, player: str, put_location_ids: list[int], to_location_ids: list[int]):
        """
        Creates an event representing the action of putting a location into another location.
        """
        return Event(execution=execution_id, type=Event.Type.LOCATION_TAKE_FROM, time=time, data={
            "player": player,
            "put_location_ids": put_location_ids,
            "to_location_ids": to_location_ids
        })

    @staticmethod
    def location_leave(execution_id: int, time: int, player: str, leave_location_id: int):
        """
        Creates an event representing the action of leaving a location.
        """
        return Event(execution=execution_id, type=Event.Type.LOCATION_LEAVE, time=time, data={
            "player": player,
            "leave_location_id": leave_location_id
        })

    @staticmethod
    def patient_arrive(execution_id: int, time: int, player: str, patient_id: int):
        """
        Creates an event representing the action of a player arriving at a patient.
        """
        return Event(execution=execution_id, type=Event.Type.PATIENT_ARRIVE, time=time, data={
            "player": player,
            "patient_id": patient_id
        })

    @staticmethod
    def patient_classify(execution_id: int, time: int, player: str, patient_id: int, classification: str):
        """
        Creates an event representing the action of a player classifying at a patient.
        """
        return Event(execution=execution_id, type=Event.Type.PATIENT_CLASSIFY, time=time, data={
            "player": player,
            "patient_id": patient_id,
            "classification": classification
        })

    @staticmethod
    def player_alerted(execution_id: int, time: int, player: str):
        """
        Creates an event representing the alerting of a player.
        """
        return Event(execution=execution_id, type=Event.Type.PLAYER_ALERTED, time=time, data={
            "player": player,
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
        evt = LoggedEvent(execution=self.execution, type=self.type.name, time=self.time, data=self.data)  # type: ignore
        db.session.add(evt)
        db.session.commit()
