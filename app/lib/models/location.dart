import 'package:manvsim/models/resource.dart';

class Location {
  final int id;
  final String name;
  List<Resource> resource;
  List<Location> locations;

  Location(
      {required this.id,
      required this.name,
      required this.resource,
      required this.locations});

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
            resource: resources
                .map((resource) => Resource.fromJson(resource))
                .toList(),
            locations: locations
                .map((location) => Location.fromJson(location))
                .toList()),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }
}
