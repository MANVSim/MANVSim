from executions.entities.action import Action
from executions.entities.execution import Execution
from executions.entities.location import Location
from executions.entities.patient import Patient
from executions.entities.performed_action import PerformedAction
from executions.entities.player import Player
from executions.entities.resource import Resource
from executions.entities.resource_type import ResourceType
from executions.entities.scenario import Scenario


# -- Create Empty Test Objects --

def create_dummy_scenario(id: int = 0, name: str = "Dummy Scenario", patients: list[Patient] = None):
    return Scenario(id=id, name=name, patients=patients)


def create_dummy_execution(id: int = 0, scenario: Scenario = None, starting_time: int = 0, players: list[Player] = None,
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
                        duration_sec: int = 0, resource_types_needed: list[ResourceType] = None):
    return Action(id=id, name=name, result=result, picture_ref=picture_ref, duration_sec=duration_sec,
                  resource_types_needed=resource_types_needed)


def create_dummy_performed_action(id: int = 0, time: int = 0, execution_id: str = "dummy", action: Action = None,
                                  resources_used: list[Resource] = None, player_tan: str = "dummy"):
    return PerformedAction(id=id, time=time, execution_id=execution_id, action=action, resources_used=resources_used,
                           player_tan=player_tan)


def create_dummy_location(id: int = 0, name: str = "Dummy Location", picture_ref: str = "dummy.png",
                          location: 'Location' = None):
    return Location(id=id, name=name, picture_ref=picture_ref, location=location)


def create_dummy_resource_type(id: int = 0, name: str = "Dummy Resource Type", picture_ref: str = "dummy.png"):
    return ResourceType(id=id, name=name, picture_ref=picture_ref)


def create_dummy_resource(id: int = 0, location: Location = None, resource_type: ResourceType = None,
                          quantity: int = 0):
    return Resource(id=id, location=location, resource_type=resource_type, quantity=quantity)



