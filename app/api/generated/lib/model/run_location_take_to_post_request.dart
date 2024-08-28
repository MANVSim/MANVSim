//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunLocationTakeToPostRequest {
  /// Returns a new [RunLocationTakeToPostRequest] instance.
  RunLocationTakeToPostRequest({
    required this.takeLocationIds,
    required this.toLocationIds,
  });

  String takeLocationIds;

  String toLocationIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunLocationTakeToPostRequest &&
    other.takeLocationIds == takeLocationIds &&
    other.toLocationIds == toLocationIds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (takeLocationIds.hashCode) +
    (toLocationIds.hashCode);

  @override
  String toString() => 'RunLocationTakeToPostRequest[takeLocationIds=$takeLocationIds, toLocationIds=$toLocationIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'take_location_ids'] = this.takeLocationIds;
      json[r'to_location_ids'] = this.toLocationIds;
    return json;
  }

  /// Returns a new [RunLocationTakeToPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunLocationTakeToPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunLocationTakeToPostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunLocationTakeToPostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunLocationTakeToPostRequest(
        takeLocationIds: mapValueOfType<String>(json, r'take_location_ids')!,
        toLocationIds: mapValueOfType<String>(json, r'to_location_ids')!,
      );
    }
    return null;
  }

  static List<RunLocationTakeToPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunLocationTakeToPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunLocationTakeToPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunLocationTakeToPostRequest> mapFromJson(dynamic json) {
    final map = <String, RunLocationTakeToPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunLocationTakeToPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunLocationTakeToPostRequest-objects as value to a dart map
  static Map<String, List<RunLocationTakeToPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunLocationTakeToPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunLocationTakeToPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'take_location_ids',
    'to_location_ids',
  };
}

