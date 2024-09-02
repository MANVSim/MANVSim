import json
import logging

from flask import Blueprint, request
from werkzeug.exceptions import NotFound, BadRequest

import models
from app_config import db
from scenario.web_api.utils import update_media
from utils.decorator import required, RequiredValueSource, role_required

# pyright: reportCallIssue=false
# pyright: reportAttributeAccessIssue=false
# The following statements are excluded from pyright, due to ORM specifics.

web_api = Blueprint("web_api-location", __name__)


@web_api.get("/location/all-vehicles")
@role_required(models.WebUser.Role.READ_ONLY)
def get_all_vehicle_locations():
    """ Returns a json of all locations stored. """
    location_list = models.Location.query.filter_by(
        is_vehicle=True
    ).all()
    return [
        {
            "id": location.id,
            "name": location.name,
        } for location in location_list
    ]


@web_api.get("/location/all")
@role_required(models.WebUser.Role.READ_ONLY)
def get_all_locations():
    """ Returns a json of all locations stored. """
    location_list = models.Location.query.all()
    return [
        {
            "id": location.id,
            "name": location.name,
        } for location in location_list
    ]

@web_api.get("/location")
@role_required(models.WebUser.Role.READ_ONLY)
@required("location_id", int, RequiredValueSource.ARGS)
def get_location(location_id: int):

    location = models.Location.query.filter_by(id=location_id).first()

    if not location:
        raise NotFound(f"location not found by id={location_id}")

    location_relations = models.LocationContainsLocation.query.filter_by(
        parent=location.id
    )

    resource_relations = models.ResourceInLocation.query.filter_by(
        location_id=location_id
    ).all()

    return {
        "id": location.id,
        "name": location.name,
        "is_vehicle": location.is_vehicle,
        "media_refs": json.loads(
            location.media_refs) if location.media_refs else [],
        "child_locations": [
            {
                "id": location_relation.child_location.id,
                "name": location_relation.child_location.name
            } for location_relation in location_relations
        ],
        "resources": [
            {
                "id": resource.resource.id,
                "name": resource.resource.name,
                "quantity": resource.quantity
            } for resource in resource_relations
        ]
    }


@web_api.post("/location")
def create_location():
    location = models.Location(
        name="Neue Location",
        media_refs=[],
        is_vehicle=False,
    )

    db.session.add(location)
    db.session.commit()

    return {
        "id": location.id,
        "name": location.name,
        "is_vehicle": location.is_vehicle,
        "media_refs": [],
        "child_locations": []
    }


@web_api.patch("/location")
@required("id", int, RequiredValueSource.JSON)
def edit_location(id: int):

    location = models.Location.query.filter_by(id=id).first()

    if not location:
        raise NotFound(f"location not found by id={id}")

    request_data = request.get_json()

    try:
        # name
        location.name = request_data["name"]
    except KeyError:
        logging.debug("no name changes detected.")

    try:
        # is_vehicle
        location.is_vehicle = request_data["is_vehicle"] == "True"
    except KeyError:
        logging.debug("no is_vehicle changes detected.")

    try:
        media_refs_add = request_data["media_refs_add"]
        update_media(dbo=location, media_refs_add=media_refs_add)
    except KeyError:
        logging.debug("No media-add change detected.")

    try:
        media_refs_del = request_data["media_refs_del"]
        update_media(dbo=location, media_refs_del=media_refs_del)
    except KeyError:
        logging.debug("No media-del change detected.")

    try:
        # resource
        resources = request_data["resources"]
        __update_resources(location, resources)
    except KeyError:
        logging.debug("no resource changes detected.")

    try:
        # location-add
        locations_add = request_data["location_add"]
        __update_child_locations(location, locations_add=locations_add)
    except KeyError:
        logging.debug("no location-add changes detected.")

    try:
        # location-del
        pass
    except KeyError:
        logging.debug("no location-del changes detected.")

    db.session.commit()
    return "Successfully updated location", 200


def __update_resources(location, resources):
    try:
        for resource_data in resources:
            resource = models.ResourceInLocation.query.filter_by(
                location_id=location.id,
                resource_id=resource_data["id"]
            ).first()
            quantity = int(resource_data["quantity"])
            if quantity <= 0 and not resource:
                continue
            elif not resource:
                resource = models.ResourceInLocation(
                    quantity=quantity,
                    location_id=location.id,
                    resource_id=resource_data["id"]
                )
                db.session.add(resource)
            elif quantity <= 0:
                db.session.delete(resource)
            else:
                resource.quantity = resource_data["resource_data"]

    except KeyError:
        raise BadRequest("Invalid or missing parameter for patients detected")


def __update_child_locations(location, locations_add=None, locations_del=None):

    if locations_add is None:
        locations_add = []

    if locations_del is None:
        locations_del = []

    # delete nested child- from parent-location
    for location_del in locations_del:
        child_location = models.LocationContainsLocation.query.filter_by(
            parent=location.id,
            child=location_del
        )
        if child_location:
            db.session.delete(child_location)

    # add new location to location
    for location_add in locations_add:
        child_location = models.LocationContainsLocation.query.filter_by(
            parent=location.id,
            child=location_add
        ).first()

        if child_location:
            relation = models.LocationContainsLocation(
                parent=location.id,
                child=child_location.id
            )
            db.session.add(relation)
