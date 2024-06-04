class MultiMedia {

  String? text;
  String? imageRef;

  MultiMedia({this.text, this.imageRef});

  factory MultiMedia.fromJson(Map<String, dynamic> json) {
    MultiMedia mm = MultiMedia();
    // Easily add new optional properties
    // Allows for keys to miss or having null value
    if (mm case {"text": String? text}) mm.text = text;
    if (mm case {"image_ref": String? imageRef}) mm.imageRef = imageRef;
    return mm;
  }
}
