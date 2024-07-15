//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class LocationDTO {
  /// Returns a new [LocationDTO] instance.
  LocationDTO({
    required this.id,
    required this.name,
    this.resources = const [],
    this.subLocations = const [],
  });

  int id;

  String name;

  List<ResourceDTO> resources;

  List<LocationDTO> subLocations;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationDTO &&
    other.id == id &&
    other.name == name &&
    _deepEquality.equals(other.resources, resources) &&
    _deepEquality.equals(other.subLocations, subLocations);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (resources.hashCode) +
    (subLocations.hashCode);

  @override
  String toString() => 'LocationDTO[id=$id, name=$name, resources=$resources, subLocations=$subLocations]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'resources'] = this.resources;
      json[r'sub_locations'] = this.subLocations;
    return json;
  }

  /// Returns a new [LocationDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LocationDTO[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LocationDTO[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LocationDTO(
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        resources: ResourceDTO.listFromJson(json[r'resources']),
        subLocations: LocationDTO.listFromJson(json[r'sub_locations']),
      );
    }
    return null;
  }

  static List<LocationDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LocationDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationDTO> mapFromJson(dynamic json) {
    final map = <String, LocationDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationDTO-objects as value to a dart map
  static Map<String, List<LocationDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LocationDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'resources',
    'sub_locations',
  };
}

