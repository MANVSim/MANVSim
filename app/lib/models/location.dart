import 'package:manv_api/api.dart';
import 'package:manvsim/models/resource.dart';

class Location {
  final int id;
  final String name;
  List<Resource> resources;
  List<Location> locations;

  Location(
      {required this.id,
      required this.name,
      required this.resources,
      required this.locations});

  factory Location.fromApi(LocationDTO dto) {
    if (dto.id == null || dto.name == null) {
      throw const FormatException('Failed to parse patient from JSON.');
    }
    return Location(
        id: dto.id!,
        name: dto.name!,
        resources: dto.resources
            .map((resourceDto) => Resource.fromApi(resourceDto))
            .toList(),
        locations: dto.locations
            .map((locationDto) => Location.fromApi(locationDto))
            .toList());
  }

  List<Resource> flattenResources() {
    return resources + flattenResourcesFromList(locations);
  }

  static List<Resource> flattenResourcesFromList(List<Location> locations) {
    return locations.map((l) => l.flattenResources()).expand((r) => r).toList();
  }
}
