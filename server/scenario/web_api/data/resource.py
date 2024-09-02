import json
import logging

from flask import Blueprint, request
from werkzeug.exceptions import NotFound

import models
from app_config import db
from scenario.web_api.utils import update_media
from utils.decorator import RequiredValueSource, required, role_required

# pyright: reportCallIssue=false
# pyright: reportAttributeAccessIssue=false
# The following statements are excluded from pyright, due to ORM specifics.

web_api = Blueprint("web_api-resource", __name__)


@web_api.get("/resource/all")
@role_required(models.WebUser.Role.READ_ONLY)
def get_all_resources():
    """ Returns a json of all resources stored. """
    resource_list = models.Resource.query.all()
    return [
        {
            "id": resource.id,
            "name": resource.name,
        } for resource in resource_list
    ]


@web_api.get("/resource")
@role_required(models.WebUser.Role.READ_ONLY)
@required("resource_id", int, RequiredValueSource.ARGS)
def get_resource(resource_id: int):

    resource = models.Resource.query.filter_by(id=resource_id).first()

    if not resource:
        raise NotFound(f"resource not found by id={resource_id}")

    return {
        "id": resource.id,
        "name": resource.name,
        "consumable": resource.consumable,
        "media_refs": json.loads(
            resource.media_refs) if resource.media_refs else [],
    }


@web_api.post("/resource")
def create_resource():
    resource = models.Resource(
        name="Neue Resource",
        consumable="False",
        quantity=10000,
        media_refs=[]
    )

    db.session.add(resource)
    db.session.commit()

    return {
        "id": resource.id,
        "name": resource.name,
        "consumable": resource.consumable,
        "media_refs": [],
    }


@web_api.patch("/resource")
@required("id", int, RequiredValueSource.JSON)
def edit_resource(id: int):

    resource = models.Resource.query.filter_by(id=id).first()

    if not resource:
        raise NotFound(f"resource not found by id={id}")

    request_data = request.get_json()
    try:
        resource.name = int(request_data["name"])
    except KeyError:
        logging.debug("No name change detected ")

    try:
        boolean = request_data["consumable"] == "True"
        if not boolean:
            resource.quantity = 10000

        resource.consumable = boolean
    except KeyError:
        logging.debug("No consumable changes detected ")

    try:
        media_refs_add = request_data["media_refs_add"]
        update_media(dbo=resource, media_refs_add=media_refs_add)
    except KeyError:
        logging.debug("No media-add change detected.")

    try:
        media_refs_del = request_data["media_refs_del"]
        update_media(dbo=resource, media_refs_del=media_refs_del)
    except KeyError:
        logging.debug("No media-del change detected.")

    db.session.commit()
    return "Successfully updated resource", 200
