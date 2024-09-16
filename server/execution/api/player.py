from flask import Blueprint
from flask_jwt_extended import jwt_required

from execution.utils import util

api = Blueprint("api-player", __name__)


@api.get("/player/inventory")
@jwt_required()
def get_player_inventory():
    """ Returns the current inventory of the requesting player. """
    try:
        _, player = util.get_execution_and_player()
        return {
            "accessible_locations": [
                location.to_dict() for location in player.accessible_locations
            ]
        }
    except KeyError:
        return f"Missing or invalid request parameter detected.", 400
