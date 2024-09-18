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
                 "patient_id": patient.id,
                 "classification": patient.classification.name}
                for patient in execution.scenario.patients.values()
            ],
            "location_positions": [
                {"position": {"x": random() * 1500, "y": random() * 1500},
                 "location_id": location.id}
                for location in execution.scenario.locations.values()
                if location.available],
            "buildings": [
                {"top_left": {"x": 100, "y": 120}, "width": 110, "height": 120},
                {"top_left": {"x": 100, "y": 730}, "width": 200, "height": 250},
                {"top_left": {"x": 300, "y": 150}, "width": 610, "height": 90},
                {"top_left": {"x": 700, "y": 750}, "width": 210, "height": 180},
                {"top_left": {"x": 340, "y": 330}, "width": 180, "height": 200},
                {"top_left": {"x": 1200, "y": 920}, "width": 110, "height": 120},
                {"top_left": {"x": 1030, "y": 730}, "width": 200, "height": 250},
                {"top_left": {"x": 1340, "y": 150}, "width": 610, "height": 90},
                {"top_left": {"x": 1450, "y": 750}, "width": 22, "height": 1},
                {"top_left": {"x": 940, "y": 330}, "width": 60, "height": 20},
                {"top_left": {"x": 1200, "y": 1920}, "width": 110, "height": 120},
                {"top_left": {"x": 1030, "y": 1730}, "width": 200, "height": 250},
                {"top_left": {"x": 1340, "y": 1150}, "width": 610, "height": 90},
                {"top_left": {"x": 1450, "y": 1750}, "width": 22, "height": 1},
                {"top_left": {"x": 940, "y": 1330}, "width": 60, "height": 20},
            ],
            "starting_point": {"x": 600, "y": 600}
        }
    except KeyError:
        return "Missing or invalid request parameter detected.", 400
