//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunPatientAllTansGet200Response {
  /// Returns a new [RunPatientAllTansGet200Response] instance.
  RunPatientAllTansGet200Response({
    this.tans = const [],
  });

  List<int> tans;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunPatientAllTansGet200Response &&
    _deepEquality.equals(other.tans, tans);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tans.hashCode);

  @override
  String toString() => 'RunPatientAllTansGet200Response[tans=$tans]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tans'] = this.tans;
    return json;
  }

  /// Returns a new [RunPatientAllTansGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunPatientAllTansGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunPatientAllTansGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunPatientAllTansGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunPatientAllTansGet200Response(
        tans: json[r'tans'] is Iterable
            ? (json[r'tans'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<RunPatientAllTansGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunPatientAllTansGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunPatientAllTansGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunPatientAllTansGet200Response> mapFromJson(dynamic json) {
    final map = <String, RunPatientAllTansGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunPatientAllTansGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunPatientAllTansGet200Response-objects as value to a dart map
  static Map<String, List<RunPatientAllTansGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunPatientAllTansGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunPatientAllTansGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

