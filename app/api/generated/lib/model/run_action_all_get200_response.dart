//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunActionAllGet200Response {
  /// Returns a new [RunActionAllGet200Response] instance.
  RunActionAllGet200Response({
    this.actions = const [],
  });

  List<ActionDTO> actions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunActionAllGet200Response &&
    _deepEquality.equals(other.actions, actions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actions.hashCode);

  @override
  String toString() => 'RunActionAllGet200Response[actions=$actions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'actions'] = this.actions;
    return json;
  }

  /// Returns a new [RunActionAllGet200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunActionAllGet200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunActionAllGet200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunActionAllGet200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunActionAllGet200Response(
        actions: ActionDTO.listFromJson(json[r'actions']),
      );
    }
    return null;
  }

  static List<RunActionAllGet200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunActionAllGet200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunActionAllGet200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunActionAllGet200Response> mapFromJson(dynamic json) {
    final map = <String, RunActionAllGet200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunActionAllGet200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunActionAllGet200Response-objects as value to a dart map
  static Map<String, List<RunActionAllGet200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunActionAllGet200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunActionAllGet200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'actions',
  };
}

