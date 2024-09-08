//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunActionPerformResultGet200Response {
  /// Returns a new [RunActionPerformResultGet200Response] instance.
  RunActionPerformResultGet200Response({
    this.conditions = const {},
    required this.patient,
  });

  Map<String, List<MediaReferencesDTOInner>> conditions;

  PatientDTO patient;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunActionPerformResultGet200Response &&
    _deepEquality.equals(other.conditions, conditions) &&
    other.patient == patient;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conditions.hashCode) +
    (patient.hashCode);

  @override
  String toString() => 'RunActionPerformResultGet200Response[conditions=$conditions, patient=$patient]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conditions'] = this.conditions;
      json[r'patient'] = this.patient;
    return json;
  }

  /// Returns a new [RunActionPerformResultGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunActionPerformResultGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunActionPerformResultGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunActionPerformResultGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunActionPerformResultGet200Response(
        conditions: json[r'conditions'] == null
          ? const {}
            : MediaReferencesDTOInner.mapListFromJson(json[r'conditions']),
        patient: PatientDTO.fromJson(json[r'patient'])!,
      );
    }
    return null;
  }

  static List<RunActionPerformResultGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunActionPerformResultGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunActionPerformResultGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunActionPerformResultGet200Response> mapFromJson(dynamic json) {
    final map = <String, RunActionPerformResultGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunActionPerformResultGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunActionPerformResultGet200Response-objects as value to a dart map
  static Map<String, List<RunActionPerformResultGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunActionPerformResultGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunActionPerformResultGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conditions',
    'patient',
  };
}

