import json
import logging
import uuid

from utils import time


class PatientState:

    def __init__(self, state_uuid: str = str(uuid.uuid4()),
                 treatments: dict[str, str] | None = None,
                 start_time: int = -1, timelimit: int = -1,
                 after_time_state_uuid: str = "",
                 conditions: dict[str, str] | None = None):
        if not treatments:
            treatments = {}
        if not conditions:
            conditions = {}

        # the time the state was delayed due to a pause action
        self.pause_time = -1

        self.uuid = state_uuid
        self.start_time = start_time
        self.timelimit = timelimit
        self.after_time_state_uuid = after_time_state_uuid
        self.treatments = treatments
        self.conditions = conditions

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

    def add_condition(self, key: str, value: str, force_update: bool = False):
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

    def get_conditions(self, keys: list[str]):
        """
        Retrieves a dictionary of conditions, selected by the required keys,
        provided in the method parameter.
        """
        conditions = {}
        for key in keys:
            if key in self.conditions.keys():
                conditions[key] = self.conditions[key]
            else:
                conditions[key] = "Missing Value"
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

    def to_dict(self):
        return self.__dict__.copy()

    def from_dict(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)
        return self

    def to_json(self):
        return json.dumps(self.to_dict())

    def from_json(self, json_string):
        return self.from_dict(**json.loads(json_string))
