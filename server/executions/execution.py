import uuid

from scenarios.models import Scenario

exec_dict = {}


def create_execution(scn: Scenario):
    print(f"DEBUG start execution of scenario {scn.name}")
    scn_uuid = str(uuid.uuid4())
    exec_dict[scn_uuid] = scn
    return scn_uuid

def end_execution(scn_uid):
    print(f"DEBUG end execution of scenario-id {scn_uid}")
    return exec_dict.pop(scn_uid)
