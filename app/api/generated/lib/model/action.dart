//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class Action {
  /// Returns a new [Action] instance.
  Action({
    this.id,
    this.name,
    this.durationInSeconds,
    this.resourceNamesNeeded = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

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
  int? durationInSeconds;

  List<String> resourceNamesNeeded;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Action &&
    other.id == id &&
    other.name == name &&
    other.durationInSeconds == durationInSeconds &&
    _deepEquality.equals(other.resourceNamesNeeded, resourceNamesNeeded);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (durationInSeconds == null ? 0 : durationInSeconds!.hashCode) +
    (resourceNamesNeeded.hashCode);

  @override
  String toString() => 'Action[id=$id, name=$name, durationInSeconds=$durationInSeconds, resourceNamesNeeded=$resourceNamesNeeded]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.durationInSeconds != null) {
      json[r'durationInSeconds'] = this.durationInSeconds;
    } else {
      json[r'durationInSeconds'] = null;
    }
      json[r'resourceNamesNeeded'] = this.resourceNamesNeeded;
    return json;
  }

  /// Returns a new [Action] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Action? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Action[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Action[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Action(
        id: mapValueOfType<int>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        durationInSeconds: mapValueOfType<int>(json, r'durationInSeconds'),
        resourceNamesNeeded: json[r'resourceNamesNeeded'] is Iterable
            ? (json[r'resourceNamesNeeded'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<Action> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Action>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Action.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Action> mapFromJson(dynamic json) {
    final map = <String, Action>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Action.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Action-objects as value to a dart map
  static Map<String, List<Action>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Action>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Action.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

