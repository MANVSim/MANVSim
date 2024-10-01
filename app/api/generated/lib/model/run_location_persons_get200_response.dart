//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunLocationPersonsGet200Response {
  /// Returns a new [RunLocationPersonsGet200Response] instance.
  RunLocationPersonsGet200Response({
    this.players = const [],
    this.patients = const [],
  });

  List<RunLocationPersonsGet200ResponsePlayersInner> players;

  List<RunLocationPersonsGet200ResponsePatientsInner> patients;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunLocationPersonsGet200Response &&
    _deepEquality.equals(other.players, players) &&
    _deepEquality.equals(other.patients, patients);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (players.hashCode) +
    (patients.hashCode);

  @override
  String toString() => 'RunLocationPersonsGet200Response[players=$players, patients=$patients]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'players'] = this.players;
      json[r'patients'] = this.patients;
    return json;
  }

  /// Returns a new [RunLocationPersonsGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunLocationPersonsGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunLocationPersonsGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunLocationPersonsGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunLocationPersonsGet200Response(
        players: RunLocationPersonsGet200ResponsePlayersInner.listFromJson(json[r'players']),
        patients: RunLocationPersonsGet200ResponsePatientsInner.listFromJson(json[r'patients']),
      );
    }
    return null;
  }

  static List<RunLocationPersonsGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunLocationPersonsGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunLocationPersonsGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunLocationPersonsGet200Response> mapFromJson(dynamic json) {
    final map = <String, RunLocationPersonsGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunLocationPersonsGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunLocationPersonsGet200Response-objects as value to a dart map
  static Map<String, List<RunLocationPersonsGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunLocationPersonsGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunLocationPersonsGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'players',
    'patients',
  };
}

