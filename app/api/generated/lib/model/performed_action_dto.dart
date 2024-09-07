//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class PerformedActionDTO {
  /// Returns a new [PerformedActionDTO] instance.
  PerformedActionDTO({
    required this.action,
    required this.executionId,
    required this.id,
    required this.playerTan,
    this.resourcesUsed = const [],
    required this.time,
  });

  ActionDTO action;

  int executionId;

  String id;

  String playerTan;

  List<ResourceDTO> resourcesUsed;

  int time;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PerformedActionDTO &&
    other.action == action &&
    other.executionId == executionId &&
    other.id == id &&
    other.playerTan == playerTan &&
    _deepEquality.equals(other.resourcesUsed, resourcesUsed) &&
    other.time == time;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (action.hashCode) +
    (executionId.hashCode) +
    (id.hashCode) +
    (playerTan.hashCode) +
    (resourcesUsed.hashCode) +
    (time.hashCode);

  @override
  String toString() => 'PerformedActionDTO[action=$action, executionId=$executionId, id=$id, playerTan=$playerTan, resourcesUsed=$resourcesUsed, time=$time]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'action'] = this.action;
      json[r'execution_id'] = this.executionId;
      json[r'id'] = this.id;
      json[r'player_tan'] = this.playerTan;
      json[r'resources_used'] = this.resourcesUsed;
      json[r'time'] = this.time;
    return json;
  }

  /// Returns a new [PerformedActionDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PerformedActionDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PerformedActionDTO[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PerformedActionDTO[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PerformedActionDTO(
        action: ActionDTO.fromJson(json[r'action'])!,
        executionId: mapValueOfType<int>(json, r'execution_id')!,
        id: mapValueOfType<String>(json, r'id')!,
        playerTan: mapValueOfType<String>(json, r'player_tan')!,
        resourcesUsed: ResourceDTO.listFromJson(json[r'resources_used']),
        time: mapValueOfType<int>(json, r'time')!,
      );
    }
    return null;
  }

  static List<PerformedActionDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PerformedActionDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PerformedActionDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PerformedActionDTO> mapFromJson(dynamic json) {
    final map = <String, PerformedActionDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PerformedActionDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PerformedActionDTO-objects as value to a dart map
  static Map<String, List<PerformedActionDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PerformedActionDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PerformedActionDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'action',
    'execution_id',
    'id',
    'player_tan',
    'resources_used',
    'time',
  };
}

