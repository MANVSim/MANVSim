//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunPatientAllIdsGet200Response {
  /// Returns a new [RunPatientAllIdsGet200Response] instance.
  RunPatientAllIdsGet200Response({
    this.patientIds = const [],
    this.patientNames = const [],
  });

  List<int> patientIds;

  List<String> patientNames;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunPatientAllIdsGet200Response &&
    _deepEquality.equals(other.patientIds, patientIds) &&
    _deepEquality.equals(other.patientNames, patientNames);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (patientIds.hashCode) +
    (patientNames.hashCode);

  @override
  String toString() => 'RunPatientAllIdsGet200Response[patientIds=$patientIds, patientNames=$patientNames]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'patient_ids'] = this.patientIds;
      json[r'patient_names'] = this.patientNames;
    return json;
  }

  /// Returns a new [RunPatientAllIdsGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunPatientAllIdsGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunPatientAllIdsGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunPatientAllIdsGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunPatientAllIdsGet200Response(
        patientIds: json[r'patient_ids'] is Iterable
            ? (json[r'patient_ids'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        patientNames: json[r'patient_names'] is Iterable
            ? (json[r'patient_names'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<RunPatientAllIdsGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunPatientAllIdsGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunPatientAllIdsGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunPatientAllIdsGet200Response> mapFromJson(dynamic json) {
    final map = <String, RunPatientAllIdsGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunPatientAllIdsGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunPatientAllIdsGet200Response-objects as value to a dart map
  static Map<String, List<RunPatientAllIdsGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunPatientAllIdsGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunPatientAllIdsGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'patient_ids',
    'patient_names',
  };
}

