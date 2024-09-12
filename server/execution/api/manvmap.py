from random import random

from flask import Blueprint
from flask_jwt_extended import jwt_required

from execution.utils import util

api = Blueprint("api-manvmap", __name__)


@api.get("/mapdata")
@jwt_required()
def get_map_data():
    """ Returns mock map data. """
    try:
        execution, _ = util.get_execution_and_player()
        return {
            "patient_positions": [
                {"position": {"x": random() * 1000, "y": random() * 1000},
                 "patient_id": patient_id}
                for patient_id in execution.scenario.patients.keys()
            ],
            "buildings": [
                {"top_left": {"x": 100, "y": 120}, "width": 110, "height": 120},
                {"top_left": {"x": 100, "y": 730}, "width": 200, "height": 250},
                {"top_left": {"x": 300, "y": 150}, "width": 610, "height": 90},
                {"top_left": {"x": 700, "y": 750}, "width": 210, "height": 180},
                {"top_left": {"x": 340, "y": 330}, "width": 180, "height": 200},
            ],
            "starting_point": {"x": 600, "y": 600}
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
