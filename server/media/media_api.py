import os

from flask import send_from_directory, request, Blueprint, current_app, Flask
from werkzeug.utils import secure_filename


api = Blueprint("api-media", __name__)

ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".webp"}


def setup(app: Flask):
    """ Execute this before using the API to ensure full functionality. """
    os.makedirs(os.path.join(app.root_path, "media/instance"), exist_ok=True)
    app.register_blueprint(api, url_prefix="/media")


def is_allowed_format(filename: str):
    """ Checks if the filename has an allowed file extension. """
    return os.path.splitext(filename)[1] in ALLOWED_EXTENSIONS


@api.get("/static/<path:filename>")
def get_static_media(filename):
    """ Get predefined static media files. """
    return send_from_directory("media/static", filename)


@api.get("/instance/<path:filename>")
def get_instance_media(filename):
    """ Get user-uploaded static media files. """
    return send_from_directory("media/instance", filename)


# TODO: Restrict to logged-in scenario creators
@api.post("/instance/<path:filename>")
def post_instance_media(filename):
    """ Allows users to upload images to the server. """
    if "file" not in request.files:
        return "No file part in request", 400

    file = request.files["file"]

    if not file.filename:
        return "No file provided", 400

    if is_allowed_format(file.filename):
        filename = secure_filename(file.filename)
        save_path = os.path.join(current_app.root_path, "media/instance",
                                 filename)
        # TODO: Maybe also check if extension matches contents of file
        file.save(save_path)
        return "File uploaded successfully", 201
    else:
        return "Forbidden file format", 400
