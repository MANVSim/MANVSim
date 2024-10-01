//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunLocationPutToPostRequest {
  /// Returns a new [RunLocationPutToPostRequest] instance.
  RunLocationPutToPostRequest({
    required this.putLocationIds,
    required this.toLocationIds,
  });

  String putLocationIds;

  String toLocationIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunLocationPutToPostRequest &&
    other.putLocationIds == putLocationIds &&
    other.toLocationIds == toLocationIds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (putLocationIds.hashCode) +
    (toLocationIds.hashCode);

  @override
  String toString() => 'RunLocationPutToPostRequest[putLocationIds=$putLocationIds, toLocationIds=$toLocationIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'put_location_ids'] = this.putLocationIds;
      json[r'to_location_ids'] = this.toLocationIds;
    return json;
  }

  /// Returns a new [RunLocationPutToPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunLocationPutToPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunLocationPutToPostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunLocationPutToPostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunLocationPutToPostRequest(
        putLocationIds: mapValueOfType<String>(json, r'put_location_ids')!,
        toLocationIds: mapValueOfType<String>(json, r'to_location_ids')!,
      );
    }
    return null;
  }

  static List<RunLocationPutToPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunLocationPutToPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunLocationPutToPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunLocationPutToPostRequest> mapFromJson(dynamic json) {
    final map = <String, RunLocationPutToPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunLocationPutToPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunLocationPutToPostRequest-objects as value to a dart map
  static Map<String, List<RunLocationPutToPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunLocationPutToPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunLocationPutToPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'put_location_ids',
    'to_location_ids',
  };
}

