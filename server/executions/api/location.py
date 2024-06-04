from flask import request
from flask import Blueprint
from flask_jwt_extended import jwt_required

from executions.utils import util
from executions.entities.location import Location

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


@api.get("/location/take-from")
def get_location_out_of_location():
    """
    Releases a sub location of the players current location. Afterward the location is an accessible location for the
    player.
    Required Request Param:
        required_loc_id:    location identifier that shall be added to the players inventory
    """
    args: dict = request.args
    try:
        execution, player = util.get_execution_and_player()

        required_loc_id = int(args["loc_id"])

        # locate required parent location
        current_location: Location = player.location
        parent_location, required_location = current_location.get_child_location_by_id(required_loc_id)
        if required_location is None:
            return "Location not found. Update your current location-access.", 404

        # no lock needed, because only the requesting player can edit its own inventory
        player.accessible_locations.add(required_location)
        parent_location.remove_location_by_id(required_location.id)

        # TODO add removed location to top-level location.
        return {"player_location": player.location.to_dict()}

    except KeyError:
        return "Missing or invalid request parameter detected.", 400

    except TimeoutError:
        return "Unable to access runtime object. A timeout-error occurred.", 409
