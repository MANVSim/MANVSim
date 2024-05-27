from executions.entities.action import Action
from executions.entities.execution import Execution
from executions.entities.location import Location
from executions.entities.patient import Patient
from executions.entities.performed_action import PerformedAction
from executions.entities.player import Player
from executions.entities.resource import Resource
from executions.entities.scenario import Scenario


# -- Create Empty Test Objects --

def create_dummy_scenario(id: int = 0, name: str = "Dummy Scenario", actions: list[Action] = None,
                          locations: dict[str, Location] = None, patients: list[Patient] = None):
    return Scenario(id=id, name=name, locations=locations, patients=patients, actions=actions)


def create_dummy_execution(id: str = "0", scenario: Scenario = None, starting_time: int = 0,
                           players: list[Player] = None,
                           status: Execution.Status = Execution.Status.UNKNOWN):
    return Execution(id=id, scenario=scenario, starting_time=starting_time, players=players, status=status)


def create_dummy_player(tan: str = "dummy", name: str = "Dummy Player", location: Location = None,
                        accessible_locations: list[Location] = None):
    return Player(tan=tan, name=name, location=location, accessible_locations=accessible_locations)


def create_dummy_patient(id: int = 0, name: str = "Dummy Patient", injuries: str = "None",
                         activity_diagram: str = "None", location: Location = None,
                         performed_actions: list[PerformedAction] = None):
    return Patient(id=id, name=name, injuries=injuries, activity_diagram=activity_diagram, location=location,
                   performed_actions=performed_actions)


def create_dummy_action(id: int = 0, name: str = "Dummy Action", result: str = "None", picture_ref: str = "dummy.png",
                        duration_sec: int = 0, resources_needed: list[str] = None):
    return Action(id=id, name=name, result=result, picture_ref=picture_ref, duration_sec=duration_sec,
                  resources_needed=resources_needed)


def create_dummy_performed_action(id: int = 0, time: int = 0, execution_id: int = 1, action: Action = None,
                                  resources_used: list[Resource] = None, player_tan: str = "dummy"):
    return PerformedAction(id=id, time=time, execution_id=execution_id, action=action, resources_used=resources_used,
                           player_tan=player_tan)


def create_dummy_location(id: str = "0", name: str = "Dummy Location", picture_ref: str = "dummy.png",
                          resources: list[Resource] = None, location: 'Location' = None):
    return Location(id=id, name=name, picture_ref=picture_ref, resources=resources, location=location)


def create_dummy_resource(id: int = 0, name="Dummy Resource", quantity: int = 0, picture_ref: str = "dummy.png"):
    return Resource(id=id, name=name, quantity=quantity, picture_ref=picture_ref)


# -- Create Test Scenario/Execution --

def create_test_execution():
    # Resources
    res_1 = Resource(id=1, name="EKG", quantity=1, picture_ref="dummy_ekg.png")
    res_2 = Resource(id=2, name="Infusion", quantity=3, picture_ref="dummy_infusion.png")
    res_3 = Resource(id=3, name="Trage", quantity=4, picture_ref="dummy_trage.png")
    res_4 = Resource(id=4, name="Blümchenpflaster", quantity=500, picture_ref="dummy_pflaster.png")
    res_5 = Resource(id=5, name="Beatmungsgerät", quantity=1, picture_ref="dummy_beatmung.png")

    # Locations
    loc_1 = Location(id="1", name="RTW", picture_ref="dummy_rtw.jpg", resources=[res_3])
    loc_2 = Location(id="2", name="Roter Rucksack", picture_ref="dummy_rot.png", resources=[res_2, res_4],
                     location=loc_1)
    loc_3 = Location(id="3", name="Blauer Rucksack", picture_ref="dummy_blau.png", resources=[res_5], location=loc_1)
    loc_4 = Location(id="4", name="EKG", picture_ref="dummy_ekg.png", resources=[res_1], location=loc_1)
    loc_5 = Location(id="5", name="Holstein Stadion", picture_ref="dummy_location.png")

    # Players
    player_1 = Player(tan="123ABC", name="Frank Huch", location=loc_1, accessible_locations=[loc_2, loc_3, loc_4])
    player_2 = Player(tan="456DEF", name="Prof. Dr. Reinhard von Hanxleden", location=loc_1,
                      accessible_locations=[loc_2, loc_3, loc_4])

    # Actions
    action_1 = Action(id=1, name="EKG schreiben", picture_ref="placeholder.png", duration_sec=120, result="UNDEFINED",
                      resources_needed=["EKG"])
    action_2 = Action(id=2, name="Pflaster kleben", picture_ref="placeholder.png", duration_sec=10, result="UNDEFINED",
                      resources_needed=["Blümchenpflaster"])
    action_3 = Action(id=3, name="Beatmen", picture_ref="placeholder.png", duration_sec=300, result="UNDEFINED",
                      resources_needed=["Beatmungsgerät"])

    # Performed Actions
    p_act_1 = PerformedAction(id=1, time=1715459280000, execution_id=1, action=action_2, resources_used=[res_4],
                              player_tan="123ABC")

    # Patients
    patient_1 = Patient(id=1, name="Holger Hooligan", injuries="UNDEFINED", activity_diagram="UNDEFINED",
                        location=loc_5, performed_actions=[p_act_1])
    patient_2 = Patient(id=2, name="Stefan Schiri", injuries="UNDEFINED", activity_diagram="UNDEFINED",
                        location=loc_5)

    # Scenario
    location_dict = {
        "1": loc_1,
        "2": loc_2,
        "3": loc_3,
        "4": loc_4,
        "5": loc_5
    }
    scenario = Scenario(id=1, name="Schlägerei", patients=[patient_1, patient_2],
                        actions=[action_1, action_2, action_3], locations=location_dict)

    # Execution
    execution = Execution(id="1", scenario=scenario, starting_time=-1, players=[player_1, player_2],
                          status=Execution.Status.PENDING)

    return execution
