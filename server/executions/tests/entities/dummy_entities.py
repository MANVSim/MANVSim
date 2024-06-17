from executions.entities.action import Action
from executions.entities.execution import Execution
from executions.entities.location import Location
from executions.entities.patient import Patient
from executions.entities.performed_action import PerformedAction
from executions.entities.player import Player
from executions.entities.resource import Resource
from executions.entities.role import Role
from executions.entities.scenario import Scenario


# -- Create Test Scenario/Execution --

def create_test_execution():
    # Resources
    res_1 = Resource(id=1, name="EKG", quantity=1, picture_ref="dummy_ekg.png")
    res_2 = Resource(id=2, name="Infusion", quantity=3, picture_ref="dummy_infusion.png")
    res_3 = Resource(id=3, name="Trage", quantity=4, picture_ref="dummy_trage.png")
    res_4 = Resource(id=4, name="Blümchenpflaster", quantity=500, picture_ref="dummy_pflaster.png")
    res_5 = Resource(id=5, name="Beatmungsgerät", quantity=1, picture_ref="dummy_beatmung.png")

    # Locations
    loc_2 = Location(id=2, name="Roter Rucksack", picture_ref="dummy_rot.png", resources=[res_2, res_4])
    loc_3 = Location(id=3, name="Blauer Rucksack", picture_ref="dummy_blau.png", resources=[res_5])
    loc_4 = Location(id=4, name="EKG", picture_ref="dummy_ekg.png", resources=[res_1])
    loc_5 = Location(id=5, name="Holstein Stadion", picture_ref="dummy_location.png")
    loc_1 = Location(id=1, name="RTW", picture_ref="dummy_rtw.jpg", resources=[res_3], sub_locations={loc_2, loc_3, loc_4})

    # Roles
    role_1 = Role(id=1, name="Notärzt:in", short_name="NA", power=400)
    role_2 = Role(id=2, name="Rettungsassistent:in", short_name="RA", power=200)

    # Players
    player_1 = Player(tan="123ABC", name="Frank Huch", location=loc_1, accessible_locations={loc_2, loc_3, loc_4},
                      role=role_2, alerted=False, activation_delay_sec=10)
    player_2 = Player(tan="456DEF", name="Prof. Dr. Reinhard von Hanxleden", location=loc_1,
                      accessible_locations={loc_2, loc_3, loc_4}, role=role_1, alerted=False,
                      activation_delay_sec=10)

    # Actions
    action_1 = Action(id=1, name="EKG schreiben", picture_ref="placeholder.png", duration_sec=120, result="UNDEFINED",
                      resources_needed=["EKG"], required_power=200)
    action_2 = Action(id=2, name="Pflaster kleben", picture_ref="placeholder.png", duration_sec=10, result="UNDEFINED",
                      resources_needed=["Blümchenpflaster"], required_power=400)
    action_3 = Action(id=3, name="Beatmen", picture_ref="placeholder.png", duration_sec=300, result="UNDEFINED",
                      resources_needed=["Beatmungsgerät"], required_power=300)

    # Performed Actions
    p_act_1 = PerformedAction(id="1", time=1715459280000, execution_id=1, action=action_2, resources_used=[res_4],
                              player_tan="123ABC")

    # Patients
    patient_1 = Patient(id=1, name="Holger Hooligan", injuries="UNDEFINED", activity_diagram="UNDEFINED",
                        location=loc_5, performed_actions=[p_act_1])
    patient_2 = Patient(id=2, name="Stefan Schiri", injuries="UNDEFINED", activity_diagram="UNDEFINED",
                        location=loc_5)

    # Scenario
    location_dict = {
        1: loc_1,
        2: loc_2,
        3: loc_3,
        4: loc_4,
        5: loc_5
    }
    patient_dict = {
        1: patient_1,
        2: patient_2
    }
    action_dict = {
        1: action_1,
        2: action_2,
        3: action_3,
    }
    scenario = Scenario(id=1, name="Schlägerei", patients=patient_dict, actions=action_dict, locations=location_dict)

    # Execution
    player_dict = {
        "123ABC": player_1,
        "456DEF": player_2
    }
    execution = Execution(id=1, scenario=scenario, starting_time=-1, players=player_dict,
                          status=Execution.Status.PENDING)

    return execution
