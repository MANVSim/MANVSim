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
    A few patient/location positions are static, the rest is generated randomly per request (thus might be unreachable).
    The buildings and last_position are static mock data.
    This is subject to change as the admin frontend might provide functionality
    to define/configure these in the future.
    For more semantic information see the specification in api.yaml.
    """

    def random_position():
        return {"x": random() * 1900, "y": random() * 1900}

    def tuple_to_position_dict(x: float, y: float, variate: bool = False):
        return {"x": x + (random() + 0.3) * 50, "y": y + (random() - 0.5) * 60} \
            if variate else {"x": x, "y": y}

    static_positions = [(60, 1012), (985, 585), (117, 67), (1825, 1825), (226, 1920), (1337, 1190),
                        (1064, 1442)]
    static_buildings = [
        (197, 738, 41, 406), (1426, 167, 170, 94), (798, 1737, 160, 233), (1514, 636, 211, 114),
        (1633, 1633, 114, 111), (161, 1724, 190, 88), (1450, 1185, 111, 267), (808, 1022, 281, 171),
        (1143, 575, 122, 134), (1045, 229, 56, 54), (466, 672, 124, 42), (249, 1687, 31, 45),
        (1800, 243, 293, 256), (1500, 836, 228, 175), (821, 621, 185, 269), (1053, 793, 61, 53),
        (274, 298, 264, 124), (231, 1236, 287, 173), (1343, 361, 180, 117), (1924, 575, 86, 132),
        (838, 465, 199, 44), (942, 194, 194, 257), (953, 1104, 300, 118), (743, 439, 299, 128),
        (733, 1260, 158, 41), (1195, 1673, 285, 287), (1969, 637, 40, 18), (1197, 1702, 162, 25)
    ]
    try:
        execution, _ = util.get_execution_and_player()
        return {
            "patient_positions": [
                {"position": tuple_to_position_dict(*static_positions[index], True)
                if (index < len(static_positions))
                else random_position(),
                 "patient_id": patient.id,
                 "classification": patient.classification.name}
                for index, patient in enumerate(execution.scenario.patients.values())
            ],
            "location_positions": [
                {"position": tuple_to_position_dict(*static_positions[index])
                if (index < len(static_positions))
                else random_position(),
                 "location_id": location.id}
                for index, location in enumerate(execution.scenario.locations.values())
                if location.available],
            "buildings": [
                {"top_left": {"x": x, "y": y}, "width": w, "height": h}
                for (x, y, w, h) in static_buildings
            ],
            "last_position": {"x": 600, "y": 1000}
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
