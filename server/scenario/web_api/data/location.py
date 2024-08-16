import json

from flask import Blueprint
from werkzeug.exceptions import NotFound

import models
from app_config import db
from utils.decorator import required, RequiredValueSource

web_api = Blueprint("web_api-location", __name__)


@web_api.get("/location/all")
def get_all_locations():
    """ Returns a json of all locations stored. """
    location_list = models.Location.query.all()
    return {
        [
            {
                "id": location.id,
                "name": location.name,
            } for location in location_list
        ]
    }


@web_api.get("/location")
@required("location_id", int, RequiredValueSource.ARGS)
def get_location(location_id: int):

    location = models.Location.query.filter_by(id=location_id).first()

    if not location:
        raise NotFound(f"location not found by id={location_id}")

    child_locations = models.Location.query.join(
        models.Location,
        models.Location.id == models.Location.location_id
    ).all()

    return {
        "id": location.id,
        "name": location.name,
        "is_vehicle": location.is_vehicle,
        "media_refs": json.loads(
            location.media_refs) if location.media_refs else {},
        "child_locations": [
            {
                "id": child_location.id,
                "name": child_location.name
            } for child_location in child_locations
        ]
    }


@web_api.post("/location")
def create_location():
    location = models.Location(
        name="Neue Location",
        media="[{}]",
        is_vehicle=False,
    )

    db.session.add(location)
    db.session.commit()

    return {
        "id": location.id,
        "name": location.name,
        "is_vehicle": location.is_vehicle,
        "media_refs": "[{}]",
        "child_locations": []
    }
