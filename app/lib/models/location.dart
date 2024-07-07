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
    // TODO
    return Location.fromJson(dto.toJson());
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'resources': List<dynamic> resources,
        'locations': List<dynamic> locations
      } =>
        Location(
            id: id,
            name: name,
            resources: resources
                .map((resource) => Resource.fromJson(resource))
                .toList(),
            locations: locations
                .map((location) => Location.fromJson(location))
                .toList()),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }

  List<Resource> flattenResources() {
    return resources + flattenResourcesFromList(locations);
  }

  static List<Resource> flattenResourcesFromList(List<Location> locations) {
    return locations.map((l) => l.flattenResources()).expand((r) => r).toList();
  }
}
