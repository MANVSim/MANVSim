//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class RunLocationPersonsGet200ResponsePlayersInner {
  /// Returns a new [RunLocationPersonsGet200ResponsePlayersInner] instance.
  RunLocationPersonsGet200ResponsePlayersInner({
    this.name,
    this.role,
    this.tan,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? role;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? tan;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunLocationPersonsGet200ResponsePlayersInner &&
    other.name == name &&
    other.role == role &&
    other.tan == tan;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (tan == null ? 0 : tan!.hashCode);

  @override
  String toString() => 'RunLocationPersonsGet200ResponsePlayersInner[name=$name, role=$role, tan=$tan]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
    if (this.tan != null) {
      json[r'tan'] = this.tan;
    } else {
      json[r'tan'] = null;
    }
    return json;
  }

  /// Returns a new [RunLocationPersonsGet200ResponsePlayersInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RunLocationPersonsGet200ResponsePlayersInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RunLocationPersonsGet200ResponsePlayersInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RunLocationPersonsGet200ResponsePlayersInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RunLocationPersonsGet200ResponsePlayersInner(
        name: mapValueOfType<String>(json, r'name'),
        role: mapValueOfType<String>(json, r'role'),
        tan: mapValueOfType<String>(json, r'tan'),
      );
    }
    return null;
  }

  static List<RunLocationPersonsGet200ResponsePlayersInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RunLocationPersonsGet200ResponsePlayersInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RunLocationPersonsGet200ResponsePlayersInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RunLocationPersonsGet200ResponsePlayersInner> mapFromJson(dynamic json) {
    final map = <String, RunLocationPersonsGet200ResponsePlayersInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RunLocationPersonsGet200ResponsePlayersInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RunLocationPersonsGet200ResponsePlayersInner-objects as value to a dart map
  static Map<String, List<RunLocationPersonsGet200ResponsePlayersInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RunLocationPersonsGet200ResponsePlayersInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RunLocationPersonsGet200ResponsePlayersInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

