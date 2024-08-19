import mimetypes
import os

import magic
from flask import send_from_directory, request, Blueprint, current_app, Flask
from werkzeug.datastructures.file_storage import FileStorage
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
    """ Allows users to upload media files to the server. Returns a MediaData-JSON. """
    if not filename:
        return "Invalid request: No filename provided", 400
    elif filename == "txt":
        return __handle_raw_text()
    else:
        return __handle_file_upload()


def __handle_file_upload():
    if "file" not in request.files:
        return "Invalid request: Missing attribute 'file' in request", 400

    file = request.files["file"]

    if not file.filename:
        return "Invalid request: No file provided", 400

    if not __check_file_content(file):
        return "Invalid request: Contents of the file and file extension do not match", 400

    filename = secure_filename(file.filename)
    extension = os.path.splitext(filename)[1]
    reference_path = "media/instance/"
    if extension in MediaData.ALLOWED_IMAGE_EXTENSIONS:
        reference_path += "image"
        result = MediaData.new_image(image_reference=f"{reference_path}/{filename}",
                                     title=request.form.get("title", default=None))
    elif extension in MediaData.ALLOWED_VIDEO_EXTENSIONS:
        reference_path += "video"
        result = MediaData.new_video(video_reference=f"{reference_path}/{filename}",
                                     title=request.form.get("title", default=None))
    elif extension in MediaData.ALLOWED_AUDIO_EXTENSIONS:
        reference_path += "audio"
        result = MediaData.new_audio(audio_reference=f"{reference_path}/{filename}",
                                     title=request.form.get("title", default=None))
    elif extension in MediaData.ALLOWED_TEXT_EXTENSIONS:
        reference_path += "text"
        result = MediaData.new_text_file(text_reference=f"{reference_path}/{filename}",
                                         title=request.form.get("title", default=None))
    else:
        return "Unsupported file format", 415

    save_path = os.path.join(current_app.root_path, reference_path, filename)
    file.save(save_path)
    return result.to_json(), 201


def __handle_raw_text():
    title = request.form.get("title", default=None)
    text = request.form.get("text", default=None)
    if not text and not title:
        return "Invalid request: Missing 'text' or 'title' attribute", 400

    return MediaData.new_text(title, text).to_json(), 201


def __check_file_content(file: FileStorage) -> bool:
    """ Checks if the file content matches the extension. """
    extension_type, _ = mimetypes.guess_type(str(file.filename))  # Get MIME type based on file extension

    file_content = file.read()
    content_type = magic.from_buffer(file_content, mime=True)  # Get MIME type of file content

    return extension_type == content_type
