import os

from flask import send_from_directory, request, Blueprint, current_app, Flask
from werkzeug.utils import secure_filename

from media.media_data import MediaData

api = Blueprint("api-media", __name__)


def setup(app: Flask):
    """ Execute this before using the API to ensure full functionality. """
    os.makedirs(os.path.join(app.root_path, "media/instance/image"),
                exist_ok=True)
    os.makedirs(os.path.join(app.root_path, "media/instance/video"),
                exist_ok=True)
    os.makedirs(os.path.join(app.root_path, "media/instance/audio"),
                exist_ok=True)
    os.makedirs(os.path.join(app.root_path, "media/instance/text"),
                exist_ok=True)
    app.register_blueprint(api, url_prefix="/media")


def is_allowed_format(filename: str):
    """ Checks if the filename has an allowed file extension. """
    return MediaData.is_allowed_extension(os.path.splitext(filename)[1])


@api.get("/static/<path:filename>")
def get_static_media(filename):
    """ Get predefined static media files. """
    return send_from_directory("media/static", filename)


@api.get("/instance/<path:filename>")
def get_instance_media(filename):
    """ Get user-uploaded static media files. """
    return send_from_directory("media/instance", filename)


# TODO: Restrict to logged-in scenario creators
@api.post("/<path:filename>")
def post_instance_media(filename):
    """ Allows users to upload media files to the server. """
    if "file" not in request.files:
        return "No file part in request", 400

    file = request.files["file"]

    if not file.filename:
        return "No file provided", 400

    filename = secure_filename(file.filename)
    extension = os.path.splitext(filename)[1]
    reference_path = "media/instance/"

    if extension in MediaData.ALLOWED_IMAGE_EXTENSIONS:
        reference_path += "image"
    elif extension in MediaData.ALLOWED_VIDEO_EXTENSIONS:
        reference_path += "video"
    elif extension in MediaData.ALLOWED_AUDIO_EXTENSIONS:
        reference_path += "audio"
    elif extension in MediaData.ALLOWED_TEXT_EXTENSIONS:
        reference_path += "text"
    else:
        return "Forbidden file format", 400

    save_path = os.path.join(current_app.root_path, reference_path, filename)
    # TODO: Maybe also check if extension matches contents of file
    file.save(save_path)
    return "File uploaded successfully", 201
