import json
import logging
import uuid

from media.media_data import MediaData
from utils import time


class PatientState:

    def __init__(self, state_uuid: str = str(uuid.uuid4()),
                 treatments: dict[str, str] | None = None,
                 start_time: int = -1, timelimit: int = -1,
                 after_time_state_uuid: str = "",
                 conditions: dict[str, list[MediaData]] | None = None,
                 pause_time: int = -1):
        if not treatments:
            treatments: dict[str, str] = {}
        if not conditions:
            conditions: dict[str, list[MediaData]] = {}

        # the time the state was delayed due to a pause action
        self.pause_time = pause_time

        self.uuid = state_uuid
        self.start_time = start_time
        self.timelimit = timelimit
        self.after_time_state_uuid = after_time_state_uuid
        self.treatments = treatments
        self.conditions = conditions

    def __repr__(self):
        return f"PatientState(uuid: {self.uuid})"

    def add_treatment(self, treatment: str, new_state_uuid: str,
                      force_update: bool = False):
        """
            Inserts an additional treatment. If the treatment is already
            provided it keeps the old state unless the force_update flags allows
             an overwrite.
        """
        if force_update or treatment not in self.treatments.keys():
            self.treatments[treatment] = new_state_uuid
            return True
        else:
            logging.warning("treatment already exist. You might force-update "
                            "the id if necessary.")
            return False

    def add_condition(self, key: str, value: list[MediaData],
                      force_update: bool = False):
        """
        Inserts an additional condition. If the condition is already
        provided it keeps the old value unless the force_update flags allows an
        overwrite.
        """
        if force_update or key not in self.conditions.keys():
            self.conditions[key] = value
            return True
        else:
            logging.warning("condition already exist. You might force-update "
                            "the id if necessary.")
            return False

    def get_conditions(self, keys: list[str]) -> dict:
        """
        Retrieves a dictionary of conditions, selected by the required keys,
        provided in the method parameter.
        """
        conditions = {}
        for key in keys:
            if key in self.conditions.keys():
                conditions[key] = [val.to_dict() for val in self.conditions[key]]
            else:
                conditions[key] = []
        return conditions

    def start_timer(self):
        """
        Initiates/restarts a timer for the state object, if a timelimit is set.
        """
        if self.timelimit == -1:
            return

        current_s = time.current_time_s()
        if self.pause_time > 0:
            # add the delay to the timestamp
            self.start_time = self.start_time + (current_s - self.pause_time)
            self.pause_time = -1  # reset pause_timer
        else:
            self.start_time = current_s

    def pause_timer(self):
        """ Pauses the state by setting a pause timestamp. """
        if self.timelimit != -1:
            return

        self.pause_time = time.current_time_s()

    def get_all_child_state_ids(self):
        return set(self.treatments.values()).add(self.after_time_state_uuid)

    def is_state_outdated(self):
        """ Returns a boolean related to the state timeout. """
        return (self.timelimit != -1 and
                self.timelimit + self.start_time <= time.current_time_s())

    def _conditions_to_dict(self) -> dict:
        result: dict[str, list[dict]] = {}
        for key, value in self.conditions.items():
            result[key] = [v.to_dict() for v in value]
        return result

    def to_dict(self) -> dict:
        result = self.__dict__.copy()
        result['conditions'] = self._conditions_to_dict()
        return result

    @staticmethod
    def __conditions_from_dict(data: dict) -> dict[str, list[MediaData]]:
        if not data:
            return {}
        result = {}
        for key, value in data.items():
            result[key] = [MediaData.from_dict(v) for v in value]
        return result

    @classmethod
    def from_dict(cls, data: dict) -> 'PatientState':
        state_uuid: str = data.get("uuid", "")
        start_time: int = data.get("start_time", -1)
        timelimit: int = data.get("timelimit", -1)
        after_time_state_uuid: str = data.get("after_time_state_uuid", "")
        treatments: dict = data.get("treatments", {})
        conditions: dict = cls.__conditions_from_dict(
            data.get("conditions", {}))
        pause_time: int = data.get("pause_time", -1)
        return cls(state_uuid, treatments, start_time, timelimit,
                   after_time_state_uuid, conditions, pause_time)

    def to_json(self) -> str:
        return json.dumps(self.to_dict())

    @classmethod
    def from_json(cls, json_string) -> 'PatientState':
        return cls.from_dict(json.loads(json_string))
