//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class MapDataDTOLocationPositionsInner {
  /// Returns a new [MapDataDTOLocationPositionsInner] instance.
  MapDataDTOLocationPositionsInner({
    required this.position,
    required this.locationId,
  });

  PointDTO position;

  int locationId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapDataDTOLocationPositionsInner &&
    other.position == position &&
    other.locationId == locationId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (position.hashCode) +
    (locationId.hashCode);

  @override
  String toString() => 'MapDataDTOLocationPositionsInner[position=$position, locationId=$locationId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'position'] = this.position;
      json[r'location_id'] = this.locationId;
    return json;
  }

  /// Returns a new [MapDataDTOLocationPositionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapDataDTOLocationPositionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapDataDTOLocationPositionsInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapDataDTOLocationPositionsInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapDataDTOLocationPositionsInner(
        position: PointDTO.fromJson(json[r'position'])!,
        locationId: mapValueOfType<int>(json, r'location_id')!,
      );
    }
    return null;
  }

  static List<MapDataDTOLocationPositionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapDataDTOLocationPositionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapDataDTOLocationPositionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapDataDTOLocationPositionsInner> mapFromJson(dynamic json) {
    final map = <String, MapDataDTOLocationPositionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapDataDTOLocationPositionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapDataDTOLocationPositionsInner-objects as value to a dart map
  static Map<String, List<MapDataDTOLocationPositionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapDataDTOLocationPositionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapDataDTOLocationPositionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'position',
    'location_id',
  };
}

