//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class PlayerSetNamePostRequest {
  /// Returns a new [PlayerSetNamePostRequest] instance.
  PlayerSetNamePostRequest({
    required this.name,
    this.forceUpdate,
  });

  /// username to be set.
  String name;

  /// An optional flag to indicate an overwrite.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? forceUpdate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlayerSetNamePostRequest &&
    other.name == name &&
    other.forceUpdate == forceUpdate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (forceUpdate == null ? 0 : forceUpdate!.hashCode);

  @override
  String toString() => 'PlayerSetNamePostRequest[name=$name, forceUpdate=$forceUpdate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.forceUpdate != null) {
      json[r'force_update'] = this.forceUpdate;
    } else {
      json[r'force_update'] = null;
    }
    return json;
  }

  /// Returns a new [PlayerSetNamePostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PlayerSetNamePostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PlayerSetNamePostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PlayerSetNamePostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PlayerSetNamePostRequest(
        name: mapValueOfType<String>(json, r'name')!,
        forceUpdate: mapValueOfType<bool>(json, r'force_update'),
      );
    }
    return null;
  }

  static List<PlayerSetNamePostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PlayerSetNamePostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PlayerSetNamePostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PlayerSetNamePostRequest> mapFromJson(dynamic json) {
    final map = <String, PlayerSetNamePostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PlayerSetNamePostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PlayerSetNamePostRequest-objects as value to a dart map
  static Map<String, List<PlayerSetNamePostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PlayerSetNamePostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PlayerSetNamePostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

