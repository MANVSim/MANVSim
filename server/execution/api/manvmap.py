from random import random

from flask import Blueprint
from flask_jwt_extended import jwt_required

from execution.utils import util

api = Blueprint("api-manvmap", __name__)


@api.get("/mapdata")
@jwt_required()
def get_map_data():
    """
    Returns all data required for the map in the app.
    The position data is generated randomly per request (thus might be unreachable).
    The buildings and last_position are static mock data.
    This is subject to change as the admin frontend might provide functionality
    to define/configure these in the future.
    For more semantic information see the specification in api.yaml.
    """
    try:
        execution, _ = util.get_execution_and_player()
        return {
            "patient_positions": [
                {"position": {"x": random() * 1900, "y": random() * 1900},
                 "patient_id": patient.id,
                 "classification": patient.classification.name}
                for patient in execution.scenario.patients.values()
            ],
            "location_positions": [
                {"position": {"x": random() * 1900, "y": random() * 1900},
                 "location_id": location.id}
                for location in execution.scenario.locations.values()
                if location.available],
            "buildings": [
                {"top_left": {"x": 202, "y": 868}, "width": 41, "height": 286},
                {"top_left": {"x": 1426, "y": 167}, "width": 170, "height": 94},
                {"top_left": {"x": 798, "y": 1937}, "width": 160, "height": 233},
                {"top_left": {"x": 1514, "y": 636}, "width": 211, "height": 114},
                {"top_left": {"x": 1533, "y": 1633}, "width": 114, "height": 111},
                {"top_left": {"x": 161, "y": 1924}, "width": 190, "height": 88},
                {"top_left": {"x": 1450, "y": 1185}, "width": 111, "height": 267},
                {"top_left": {"x": 808, "y": 1022}, "width": 281, "height": 171},
                {"top_left": {"x": 1173, "y": 609}, "width": 122, "height": 134},
                {"top_left": {"x": 1045, "y": 229}, "width": 56, "height": 54},
                {"top_left": {"x": 466, "y": 672}, "width": 124, "height": 42},
                {"top_left": {"x": 249, "y": 1687}, "width": 31, "height": 35},
                {"top_left": {"x": 1800, "y": 243}, "width": 293, "height": 256},
                {"top_left": {"x": 1500, "y": 836}, "width": 228, "height": 175},
                {"top_left": {"x": 821, "y": 621}, "width": 185, "height": 269},
                {"top_left": {"x": 1053, "y": 793}, "width": 61, "height": 53},
                {"top_left": {"x": 274, "y": 298}, "width": 264, "height": 124},
                {"top_left": {"x": 231, "y": 1236}, "width": 287, "height": 173},
                {"top_left": {"x": 1343, "y": 361}, "width": 180, "height": 117},
                {"top_left": {"x": 1924, "y": 575}, "width": 86, "height": 132},
                {"top_left": {"x": 838, "y": 465}, "width": 199, "height": 44},
                {"top_left": {"x": 942, "y": 194}, "width": 194, "height": 257},
                {"top_left": {"x": 953, "y": 1104}, "width": 300, "height": 118},
                {"top_left": {"x": 743, "y": 439}, "width": 299, "height": 128},
                {"top_left": {"x": 733, "y": 1260}, "width": 158, "height": 41},
                {"top_left": {"x": 1195, "y": 1873}, "width": 285, "height": 287},
                {"top_left": {"x": 1969, "y": 637}, "width": 40, "height": 18},
            ],
            "last_position": {"x": 600, "y": 1000}
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
