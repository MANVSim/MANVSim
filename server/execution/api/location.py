from flask import request
from flask import Blueprint
from flask_jwt_extended import jwt_required

from app_config import csrf
from execution.utils import util
from execution.entities.location import Location

api = Blueprint("api-location", __name__)


@api.get("/location/all")
@jwt_required()
def get_all_toplevel_location():
    try:
        """ Returns all locations stored in the scenario. """
        execution, _ = util.get_execution_and_player()
        return {
            "locations": [location.to_dict() for location in list(execution.scenario.locations.values())]
        }
    except KeyError:
        return f"Missing or invalid request parameter detected.", 400


@api.post("/location/take-from")
@jwt_required()
@csrf.exempt
def get_location_out_of_location():
    """
    Releases a sub location of the players current location. Afterward the location is an accessible location for the
    player.
    Required Request Param:
        required_loc_id:    location identifier that shall be added to the players inventory
    """
    args: dict = request.get_json()
    try:
        execution, player = util.get_execution_and_player()

        required_loc_id = int(args["take_location_id"])
        from_loc_id = int(args["from_location_id"])

        # locate required parent location
        from_location: Location = execution.scenario[from_loc_id]
        if from_location is None:
            return "From-Location not found. Update your current location-access.", 404

        parent_location, required_location = from_location.get_child_location_by_id(required_loc_id)
        if required_location is None:
            return "Take-Location not found. Update your current location-access.", 404

        # no lock needed, because only the requesting player can edit its own inventory
        player.accessible_locations.add(required_location)
        parent_location.remove_location_by_id(required_location.id)
        # add location back to first children of the tree, to make it reachable for the leave-operation.
        player.location.add_locations({required_location})

        return {"player_location": player.location.to_dict()}

    except KeyError:
        return "Missing or invalid request parameter detected.", 400

    except TimeoutError:
        return "Unable to access runtime object. A timeout-error occurred.", 409


@api.post("/location/leave")
@jwt_required()
@csrf.exempt
def leave_location():
    """ Leaves a location. Required for the initial arrival. The players inventory will not be edited. """
    _, player = util.get_execution_and_player()

    if player.location is None:
        return "Player is not assigned to any patient/location.", 405

    if player.location.leave_location(player.accessible_locations):
        player.location = None
    else:
        return "Unable to access runtime object. A timeout-error occurred.", 409

    return "Player successfully left location.", 200
