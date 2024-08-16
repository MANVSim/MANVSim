import json
import logging

from flask import Blueprint, request
from werkzeug.exceptions import NotFound

import models
from app_config import db
from scenario.web_api.utils import update_media
from utils.decorator import RequiredValueSource, required
from vars import RESULT_DELIMITER

web_api = Blueprint("web_api-action", __name__)


@web_api.get("/action/all")
def get_all_actions():
    """ Returns a json of all actions stored. """
    action_list = models.Action.query.all()
    return {
        [
            {
                "id": action.id,
                "name": action.name,
            } for action in action_list
        ]
    }


@web_api.get("/action")
@required("action_id", int, RequiredValueSource.ARGS)
def get_action(action_id: int):
    """ Returns an action with all its related entries. """
    action = models.Action.query.filter_by(id=action_id).first()

    if not action:
        raise NotFound(f"action not found by id={action_id}")

    min_role = models.Role.query.filter_by(power=action.required_power).first()

    resource_list = models.Resource.query.join(
        models.ResourcesNeeded,
        models.Resource.id == models.ResourcesNeeded.resource_id
    ).filter(
        models.ResourcesNeeded.action_id == action_id
    ).all()

    return {
        "id": action.id,
        "name": action.name,
        "min_role": min_role.name if min_role else None,
        "duration_secs": action.duration_secs,
        "media_refs": json.loads(action.media_refs) if action.media_refs else [],
        "results": action.results.split(RESULT_DELIMITER),
        "resources": [
            {
                "id": resource.id,
                "name": resource.name
            } for resource in resource_list
        ]
    }


@web_api.post("/action")
def create_action():
    """ Creates an empty Action and returns the dbo as JSON. """
    action = models.Action(
        name="Neue Maßnahmen",
        duration_secs=0,
        required_power=0,
        media_refs="[{}]",
        result=""
    )
    db.session.add(action)
    db.session.commit()

    min_role = models.Role.query.filter_by(power=action.required_power).first()

    return {
        "id": action.id,
        "name": action.name,
        "min_role": min_role.name if min_role else None,
        "duration_secs": action.duration_secs,
        "media_refs": action.media_refs,
        "results": "",
        "resources": []
    }


@web_api.patch("/action")
@required("id", int, RequiredValueSource.JSON)
def edit_action(id: int):
    """
    Updates an action based on the provided json. If a key is missing or any
    error occurs, the column remains the same.
    """
    request_data = request.get_json()
    action = models.Action.query.filter_by(id=id).first()
    if not action:
        raise NotFound(f"action not found by id={id}")

    try:
        action.name = request_data["name"]
    except KeyError:
        logging.debug("No name change detected.")

    try:
        new_role = request_data["min_role"]
        min_role = models.Role.query.filter_by(id=new_role["id"]).first()
        if min_role:
            action.required_power = min_role.power
        else:
            logging.warning(f"No Role found with id={new_role["id"]}.")
    except KeyError:
        logging.debug("No role change detected or "
                      "invalid role parameter provided.")

    try:
        action.duration_secs = int(request_data["duration_secs"])
    except KeyError:
        logging.debug("No duration change detected.")

    try:
        media_refs_add = request_data["media_refs_add"]
        update_media(dbo=action, media_refs_add=media_refs_add)
    except KeyError:
        logging.debug("No media-add change detected.")

    try:
        media_refs_del = request_data["media_refs_del"]
        update_media(dbo=action, media_refs_del=media_refs_del)
    except KeyError:
        logging.debug("No media-del change detected.")

    try:
        results = request_data["results"]
        action.results = RESULT_DELIMITER.join(results)
    except KeyError:
        logging.debug("No result changes detected.")

    try:
        resources = request_data["resources_add"]
        __update_resources(action, resources)
    except KeyError:
        logging.debug("No Resource-Add changes detected.")

    try:
        resources = request_data["resources_del"]
        __update_resources(action, resources)
    except KeyError:
        logging.debug("No Resource-Del changes detected.")

    db.session.commit()
    return "Successfully updated action", 200


def __update_resources(action, resources_add=None, resources_del=None):
    """ Deletes/Adds required resource entries based on parameters. """
    # Delete required resources
    for resource_id in resources_del:
        resource = models.ResourcesNeeded.query.filter_by(
            resource_id=resource_id,
            action_id=action.id
        )
        if resource:
            db.session.delete(resource)

    # Add new required resources
    for resource_id in resources_add:
        resource = models.Resource.query.filter_by(resource_id).first()
        if resource:
            resource_needed = models.ResourcesNeeded(
                action_id=action.id,
                resource_id=resource_id
            )
            db.session.add(resource_needed)
