import ast

from flask import Blueprint
from flask_jwt_extended import jwt_required

from app_config import csrf
from execution.entities.execution import Execution
from execution.utils import util
from event_logging.event import Event
from utils import time
from utils.decorator import required, RequiredValueSource

api = Blueprint("api-location", __name__)


@api.get("/location/all")
@jwt_required()
def get_all_toplevel_location():
    try:
        """ Returns all locations stored in the scenario. """
        execution, _ = util.get_execution_and_player()
        return {
            "locations": [location.to_dict() for location
                          in list(execution.scenario.locations.values())]
        }
    except KeyError:
        return f"Missing or invalid request parameter detected.", 400


@api.post("/location/take-to")
@required("take_location_ids", int, RequiredValueSource.JSON)
@required("to_location_ids", str, RequiredValueSource.JSON)
@jwt_required()
@csrf.exempt
def get_location_out_of_location(take_location_ids: str, to_location_ids: str):
    """
    Releases a sub location of the players current location. Afterward the
    location is an accessible location for the player.

    @param take_location_ids: string of index list of the location the player
                              wants to take into his inventory. The list should
                              start with a toplevel location.
                              example: "[1,2,3]"
    @param to_location_ids: string of index list of the new locations parent in
                            the players inventory. If the list is empty, the
                            item is placed as on the root level of the
                            inventory.
                            example: "[1,2,3]"
    """
    try:
        execution, player = util.get_execution_and_player()

        # convert string like "[1,2,3]" to an accessible list
        take_location_ids = ast.literal_eval(take_location_ids)
        to_location_ids = ast.literal_eval(to_location_ids)

        # locate the new location in the players location
        to_location = get_location_from_index_list(to_location_ids,
                                                   execution)

        if to_location is None:
            return ("To-Location not found. Update your current "
                    "location-access."), 404

        take_location_parent = get_location_from_index_list(
                                take_location_ids[:-1], execution)
        take_location = take_location_parent[
            take_location_ids[len(take_location_ids)-1]
        ]

        if not take_location:
            return ("Take-Location not found. Update your current "
                    "location-access."), 404

        to_location.add_locations({take_location})

        if to_location.id == player.location.id:
            # if to_location is the player location -> the take_location should
            # be placed in the inventory to guarantee a valid leave action.
            player.accessible_locations.add(take_location)
        else:
            # delete only from the location if the player location is different.
            # In this case the player does not share the resources with any
            # other player
            take_location_parent.remove_location_by_id(take_location.id)

        Event.location_take_from(execution_id=execution.id,
                                 time=time.current_time_s(),
                                 player=player.tan,
                                 take_location_ids=take_location_ids,
                                 to_location_ids=to_location_ids).log()

        return {"player_location": player.location.to_dict()}

    except KeyError | ValueError:
        return "Missing or invalid request parameter detected.", 400

    except TimeoutError:
        return "Unable to access runtime object. A timeout-error occurred.", 409


@api.post("/location/put-to")
@required("put_location_ids", int, RequiredValueSource.JSON)
@required("to_location_ids", str, RequiredValueSource.JSON)
@jwt_required()
@csrf.exempt
def put_location_to_location(put_location_ids: str, to_location_ids: str):
    """
    A method to transfer a location to another location. It can be used to
    put items out of the inventory to another selected location.

    @param put_location_ids: string of index list of location ids that is
                             selected for transfer
                             example: "[1,2,3]"
    @param to_location_ids: string of index list of location ids the selected
                            put location is selected to be placed in.
                            example: "[1,2,3]"
    """
    try:
        execution, player = util.get_execution_and_player()

        # convert string like "[1,2,3]" to an accessible list
        put_location_ids = ast.literal_eval(put_location_ids)
        to_location_ids = ast.literal_eval(to_location_ids)

        to_location = get_location_from_index_list(to_location_ids, execution)
        if not to_location:
            return ("To-Location not found. Update your current "
                    "location-access."), 404

        put_location_parent = get_location_from_index_list(
                                put_location_ids[:-1], execution)
        put_location = put_location_parent[
            put_location_ids[len(put_location_ids)-1]
        ]

        if not put_location_parent or not put_location:
            return ("Put-Location not found. Update your current "
                    "location-access."), 404

        if put_location_parent == player.location.id:
            # if location parent is the players current location -> only the
            # inventory is edited to guarantee a valid leave action.
            player.accessible_locations.pop(put_location)
        else:
            # otherwise perform default remove and add action
            put_location_parent.remove_location_by_id(put_location.id)
            to_location.add_locations({put_location})

        Event.location_put_to(execution_id=execution.id,
                              time=time.current_time_s(),
                              player=player.tan,
                              put_location_ids=put_location_ids,
                              to_location_ids=to_location_ids).log()

        return {"player_location": player.location.to_dict()}

    except KeyError | ValueError:
        return "Missing or invalid request parameter detected.", 400

    except TimeoutError:
        return "Unable to access runtime object. A timeout-error occurred.", 409


@api.post("/location/leave")
@jwt_required()
@csrf.exempt
def leave_location():
    """
    Leaves a location. Required for the initial arrival. The players
    inventory will not be edited.
    """
    exec, player = util.get_execution_and_player()

    if player.location is None:
        return "Player is not assigned to any patient/location.", 405

    if player.location.leave_location(player.accessible_locations):
        Event.location_leave(execution_id=exec.id,
                             time=time.current_time_s(),
                             player=player.tan,
                             leave_location_id=player.location.id).log()
        player.location = None
    else:
        return "Unable to access runtime object. A timeout-error occurred.", 409

    return {"message": "Player successfully left location."}


def get_location_from_index_list(id_list: list[int], execution: Execution):
    target_location = None
    if not id_list:
        return target_location
    for i in range(len(id_list)):
        if i == 0:
            target_location = execution.scenario.locations[id_list[i]]
        else:
            target_location = target_location.sub_locations[id_list[i]]

    return target_location
