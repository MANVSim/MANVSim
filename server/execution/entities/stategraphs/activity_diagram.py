import json
import logging

from execution.entities.stategraphs.patientstate import PatientState
from execution.utils.timeoutlock import TimeoutLock
from utils import time
from vars import ACQUIRE_TIMEOUT


# Suppresses "unexpected argument" warning for the lock.acquire_timeout()
# method. PyCharm does not recognize the parameter in the related method
# definition.
# noinspection PyArgumentList
class ActivityDiagram:

    def __init__(self, root: PatientState | None = None, states: list[PatientState] | None = None):
        if not states:
            states = []

        if root:
            self.current: PatientState = root
        else:
            self.current = PatientState()
            states.append(self.current)

        self.states: dict[str, PatientState] = {}
        self.lock = TimeoutLock()
        self.__create_state_dict(states)

    def start_current_state(self):
        """ Initiates the timer of 'current' state of the activity-diagram. """
        with self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if not acquired:
                raise TimeoutError
            self.current.start_timer()

    def pause_current_state(self):
        """ Pauses the timer of the 'current' state of the activity-diagram. """
        with self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if not acquired:
                raise TimeoutError
            self.current.pause_timer()

    def apply_treatment(self, treatment: str):
        """
            A game-method to eventually change states after an action was performed.
            It further checks if the state is still active or has changed due to a timeout. If a timeout occurs, the
            current state is updated and the action applied to the new state.
        """
        with self.lock.acquire_timeout(timeout=ACQUIRE_TIMEOUT) as acquired:
            if not acquired:
                raise TimeoutError
            if self.current.is_state_outdated():
                self.__update_state(self.current)

            try:
                new_state_uuid = self.current.treatments[treatment]
                self.current = self.__get_state_by_id(new_state_uuid)
                if self.current.timelimit != -1:
                    self.current.start_timer()
            except KeyError:
                logging.debug(f"Unable to identify treatment on current_state: {self.current.uuid}")

    def add_state(self, state: PatientState, force_update: bool = False):
        """ An administration method to extend the activity diagram with another state. """
        if force_update or state.uuid not in self.states.keys():
            self.states[state.uuid] = state
            return True
        else:
            logging.warning("state_uuid already present. You might force-update the id if necessary.")
            return False

    def to_dict(self):
        result = {}
        for key, value in self.__dict__.items():
            if hasattr(value, '__dict__'):
                result[key] = value.to_dict()
            elif isinstance(value, dict):
                result[key] = {dict_key: dictvalue.to_dict() for dict_key, dictvalue in value.items()}
            else:
                result[key] = value
        return result

    def from_dict(self, **kwargs):
        for key, value in kwargs.items():
            if key == "states":
                setattr(self, key,
                        {dict_key: PatientState().from_dict(**dict_value) for dict_key, dict_value in value.items()})
            elif key == "current":
                setattr(self, key, PatientState().from_dict(**value))
            else:
                setattr(self, key, value)
        return self

    def to_json(self):
        return json.dumps(self.to_dict())

    def from_json(self, json_string):
        return self.from_dict(**json.loads(json_string))

    def __update_state(self, state: PatientState):
        timeout = state.start_time + state.timelimit  # timestamp when state changed

        new_state: PatientState = self.__get_state_by_id(self.current.after_time_state_uuid)
        timeout_next_state = timeout + new_state.timelimit  # new start_time for next state

        # dash through states iff next state is also outdated
        while new_state.timelimit != -1 and timeout_next_state <= time.current_time_s():
            new_state = self.__get_state_by_id(new_state.after_time_state_uuid)
            timeout_next_state += new_state.timelimit

        # configure new state
        new_state.start_time = timeout_next_state
        self.current = new_state

    def __get_state_by_id(self, uuid):
        if uuid in self.states.keys():
            return self.states[uuid]
        else:
            raise Exception("Inconsistency in activity diagram. Missing state in global dictionary")

    def __create_state_dict(self, states: list[PatientState]):
        for state in states:
            self.states[state.uuid] = state
