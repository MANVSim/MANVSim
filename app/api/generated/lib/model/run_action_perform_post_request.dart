//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunActionPerformPostRequest {
  /// Returns a new [RunActionPerformPostRequest] instance.
  RunActionPerformPostRequest({
    this.actionId,
    this.patientId,
    this.resources = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? actionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? patientId;

  /// Each quantity required, needs to be an id in the array. Saying resource 0 is required 3 times, then id '0' needs to occur three 3 times in the array.
  List<int> resources;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunActionPerformPostRequest &&
    other.actionId == actionId &&
    other.patientId == patientId &&
    _deepEquality.equals(other.resources, resources);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actionId == null ? 0 : actionId!.hashCode) +
    (patientId == null ? 0 : patientId!.hashCode) +
    (resources.hashCode);

  @override
  String toString() => 'RunActionPerformPostRequest[actionId=$actionId, patientId=$patientId, resources=$resources]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.actionId != null) {
      json[r'action_id'] = this.actionId;
    } else {
      json[r'action_id'] = null;
    }
    if (this.patientId != null) {
      json[r'patient_id'] = this.patientId;
    } else {
      json[r'patient_id'] = null;
    }
      json[r'resources'] = this.resources;
    return json;
  }

  /// Returns a new [RunActionPerformPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunActionPerformPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunActionPerformPostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunActionPerformPostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunActionPerformPostRequest(
        actionId: mapValueOfType<int>(json, r'action_id'),
        patientId: mapValueOfType<int>(json, r'patient_id'),
        resources: json[r'resources'] is Iterable
            ? (json[r'resources'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<RunActionPerformPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunActionPerformPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunActionPerformPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunActionPerformPostRequest> mapFromJson(dynamic json) {
    final map = <String, RunActionPerformPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunActionPerformPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunActionPerformPostRequest-objects as value to a dart map
  static Map<String, List<RunActionPerformPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunActionPerformPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunActionPerformPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

