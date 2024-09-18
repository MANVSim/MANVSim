//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunPatientClassifyPostRequest {
  /// Returns a new [RunPatientClassifyPostRequest] instance.
  RunPatientClassifyPostRequest({
    required this.patientId,
    required this.classification,
  });

  int patientId;

  String classification;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunPatientClassifyPostRequest &&
    other.patientId == patientId &&
    other.classification == classification;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (patientId.hashCode) +
    (classification.hashCode);

  @override
  String toString() => 'RunPatientClassifyPostRequest[patientId=$patientId, classification=$classification]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'patient_id'] = this.patientId;
      json[r'classification'] = this.classification;
    return json;
  }

  /// Returns a new [RunPatientClassifyPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunPatientClassifyPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunPatientClassifyPostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunPatientClassifyPostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunPatientClassifyPostRequest(
        patientId: mapValueOfType<int>(json, r'patient_id')!,
        classification: mapValueOfType<String>(json, r'classification')!,
      );
    }
    return null;
  }

  static List<RunPatientClassifyPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunPatientClassifyPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunPatientClassifyPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunPatientClassifyPostRequest> mapFromJson(dynamic json) {
    final map = <String, RunPatientClassifyPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunPatientClassifyPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunPatientClassifyPostRequest-objects as value to a dart map
  static Map<String, List<RunPatientClassifyPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunPatientClassifyPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunPatientClassifyPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'patient_id',
    'classification',
  };
}

