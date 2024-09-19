//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class ScenarioStartTimeGet200Response {
  /// Returns a new [ScenarioStartTimeGet200Response] instance.
  ScenarioStartTimeGet200Response({
    required this.startingTime,
    this.arrivalTime,
  });

  /// Timestamp in seconds since unix epoch.
  int startingTime;

  /// Timestamp in seconds since unix epoch, indicating the time the player arrives. This parameter is only provided, if a player is alerted.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? arrivalTime;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ScenarioStartTimeGet200Response &&
    other.startingTime == startingTime &&
    other.arrivalTime == arrivalTime;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (startingTime.hashCode) +
    (arrivalTime == null ? 0 : arrivalTime!.hashCode);

  @override
  String toString() => 'ScenarioStartTimeGet200Response[startingTime=$startingTime, arrivalTime=$arrivalTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'starting_time'] = this.startingTime;
    if (this.arrivalTime != null) {
      json[r'arrival_time'] = this.arrivalTime;
    } else {
      json[r'arrival_time'] = null;
    }
    return json;
  }

  /// Returns a new [ScenarioStartTimeGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ScenarioStartTimeGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ScenarioStartTimeGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ScenarioStartTimeGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ScenarioStartTimeGet200Response(
        startingTime: mapValueOfType<int>(json, r'starting_time')!,
        arrivalTime: mapValueOfType<int>(json, r'arrival_time'),
      );
    }
    return null;
  }

  static List<ScenarioStartTimeGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ScenarioStartTimeGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ScenarioStartTimeGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ScenarioStartTimeGet200Response> mapFromJson(dynamic json) {
    final map = <String, ScenarioStartTimeGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ScenarioStartTimeGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ScenarioStartTimeGet200Response-objects as value to a dart map
  static Map<String, List<ScenarioStartTimeGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ScenarioStartTimeGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ScenarioStartTimeGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'starting_time',
  };
}

