import 'package:manv_api/api.dart';
import 'package:manvsim/models/resource.dart';

import 'multi_media.dart';

class Location {
  final int id;
  final String name;
  List<Resource> resources;
  List<Location> locations;
  MultiMediaCollection media;

  Location(
      {required this.id,
      required this.name,
      required this.resources,
      required this.locations,
      required this.media});

  factory Location.fromApi(LocationDTO dto) {
    return Location(
        id: dto.id,
        name: dto.name,
        resources: dto.resources // TODO filter quantity 0
            .map((resourceDto) => Resource.fromApi(resourceDto))
            .toList(),
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences),
        locations: dto.subLocations
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
