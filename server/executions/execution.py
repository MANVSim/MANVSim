"""
This file is the main execution module file. It contains all valid methods to create a scenario-game
along with scenario-state-changing methods. It uses DBO instances of the web-module and logs any
action of interest into a separate file (FIXME: docu update @Louis)
"""

import uuid

# Dictionary storing the current available scenarios, whether they are PENDING, RUNNING or about to FINISH
exec_dict = {
    # "scn_uuid": "scn: scenario_dbo"
}


def create_execution(scn):
    """ Dummy method to present a possible entry point for a scenario creation """
    print(f"DEBUG start execution of scenario {scn.name}")
    scn_uuid = str(uuid.uuid4())
    exec_dict[scn_uuid] = scn
    return scn_uuid


def end_execution(scn_uid):
    """ Dummy method to present a possible entry point for a scenario deletion """
    print(f"DEBUG end execution of scenario-id {scn_uid}")
    return exec_dict.pop(scn_uid)
