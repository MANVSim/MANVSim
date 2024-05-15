import json
import time
import uuid


class PatientState:

    def __init__(self, state_uuid: str = str(uuid.uuid4()), treatments=None, start_time: int = -1,
                 timelimit: int = -1, after_time_state_uuid=""):
        if treatments is None:
            treatments: dict[str, str] = {}

        self.uuid = state_uuid
        self.start_time = start_time
        self.timelimit = timelimit
        self.after_time_state_uuid = after_time_state_uuid
        self.treatments = treatments

    def add_treatment(self, treatment: str, new_state_uuid: str, force_update=False):
        """
            Inserts an additional treatment, that leads to a state change. If the treatment is already
            provided it keeps the old state unless the force_update flags allows an overwrite.
        """
        if force_update or treatment not in self.treatments.keys():
            self.treatments[treatment] = new_state_uuid
            return True
        else:
            print("Warning: treatment already exist. You might force-update the id if necessary.")
            return False

    def start_timer(self):
        """ Initiates a timer for the state object, if a timelimit is set. """
        if self.timelimit != -1:
            self.start_time = round(time.time())
            return True
        else:
            print("ERROR: unable to start error, due to missing run time.")
            return False

    def get_all_states(self):
        return list(self.treatments.values()).append(self.after_time_state_uuid)

    def is_state_changing(self, treatment):
        """ Returns true if state stores an outgoing edge related to provided treatment """
        return treatment in self.treatments.keys()

    def is_state_outdated(self):
        """ Returns a boolean related to the state timeout. """
        return self.timelimit != -1 and self.timelimit + self.start_time <= round(time.time())

    def to_dict(self):
        return self.__dict__

    def from_dict(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)
        return self

    def to_json(self):
        return json.dumps(self.to_dict())

    def from_json(self, json_string):
        return self.from_dict(**json.loads(json_string))
