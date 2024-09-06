import 'package:manv_api/api.dart';

enum MediaType {
  image,
  video,
  text,
  audio;

  static MediaType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'text':
        return MediaType.text;
      case 'audio':
        return MediaType.audio;
      default:
        throw ArgumentError('Unknown media type: $type');
    }
  }
}

class MultiMediaItem {
  String? reference;
  MediaType type;
  String? text;
  String? title;

  factory MultiMediaItem.fromApi(MediaReferencesDTOInner referenceDto) {

    return MultiMediaItem(
      reference: referenceDto.mediaReference,
      type: MediaType.fromString(referenceDto.mediaType.toString()),
      text: referenceDto.text,
      title: referenceDto.title,
    );
  }

  MultiMediaItem({this.reference, required this.type, this.text, this.title});
}

typedef MultiMediaCollection = List<MultiMediaItem>;

extension MultiMediaCollectionExtension on MultiMediaCollection {
  static MultiMediaCollection fromApi(List<MediaReferencesDTOInner> mediaReferencesDTOList) {
    return mediaReferencesDTOList
        .map((mediaReferenceDto) => MultiMediaItem.fromApi(mediaReferenceDto))
        .toList();
  }
}
