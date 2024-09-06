import 'package:manv_api/api.dart';

import 'multi_media.dart';

class Resource {
  final int id;
  final String name;
  final MultiMediaCollection media;
  int quantity;
  bool selected = false;

  Resource({required this.id, required this.name, required this.quantity, required this.media});

  factory Resource.fromApi(ResourceDTO dto) {
    return Resource(id: dto.id, name: dto.name, quantity: dto.quantity, media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences));
  }
}
