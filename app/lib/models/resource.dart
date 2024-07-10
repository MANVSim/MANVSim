import 'package:manv_api/api.dart';

class Resource {
  final int id;
  final String name;
  int quantity;
  bool selected = false;

  Resource({required this.id, required this.name, required this.quantity});

  factory Resource.fromApi(ResourceDTO dto) {
    if ([dto.id, dto.name, dto.quantity].contains(null)) {
      throw const FormatException('Failed to parse resource from JSON.');
    }
    return Resource(id: dto.id!, name: dto.name!, quantity: dto.quantity!);
  }
}
