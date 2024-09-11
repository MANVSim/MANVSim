//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class MapDataDTOPatientPositionsInner {
  /// Returns a new [MapDataDTOPatientPositionsInner] instance.
  MapDataDTOPatientPositionsInner({
    required this.position,
    required this.patientId,
  });

  PointDTO position;

  int patientId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapDataDTOPatientPositionsInner &&
    other.position == position &&
    other.patientId == patientId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (position.hashCode) +
    (patientId.hashCode);

  @override
  String toString() => 'MapDataDTOPatientPositionsInner[position=$position, patientId=$patientId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'position'] = this.position;
      json[r'patient_id'] = this.patientId;
    return json;
  }

  /// Returns a new [MapDataDTOPatientPositionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapDataDTOPatientPositionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapDataDTOPatientPositionsInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapDataDTOPatientPositionsInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapDataDTOPatientPositionsInner(
        position: PointDTO.fromJson(json[r'position'])!,
        patientId: mapValueOfType<int>(json, r'patient_id')!,
      );
    }
    return null;
  }

  static List<MapDataDTOPatientPositionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapDataDTOPatientPositionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapDataDTOPatientPositionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapDataDTOPatientPositionsInner> mapFromJson(dynamic json) {
    final map = <String, MapDataDTOPatientPositionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapDataDTOPatientPositionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapDataDTOPatientPositionsInner-objects as value to a dart map
  static Map<String, List<MapDataDTOPatientPositionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapDataDTOPatientPositionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapDataDTOPatientPositionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'position',
    'patient_id',
  };
}

