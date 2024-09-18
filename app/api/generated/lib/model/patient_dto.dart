//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class PatientDTO {
  /// Returns a new [PatientDTO] instance.
  PatientDTO({
    required this.classification,
    required this.id,
    required this.name,
    required this.location,
    this.mediaReferences = const [],
    this.performedActions = const [],
  });

  PatientClassification classification;

  int id;

  String name;

  LocationDTO location;

  List<MediaReferencesDTOInner> mediaReferences;

  List<PerformedActionDTO> performedActions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PatientDTO &&
    other.classification == classification &&
    other.id == id &&
    other.name == name &&
    other.location == location &&
    _deepEquality.equals(other.mediaReferences, mediaReferences) &&
    _deepEquality.equals(other.performedActions, performedActions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (classification.hashCode) +
    (id.hashCode) +
    (name.hashCode) +
    (location.hashCode) +
    (mediaReferences.hashCode) +
    (performedActions.hashCode);

  @override
  String toString() => 'PatientDTO[classification=$classification, id=$id, name=$name, location=$location, mediaReferences=$mediaReferences, performedActions=$performedActions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'classification'] = this.classification;
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'location'] = this.location;
      json[r'media_references'] = this.mediaReferences;
      json[r'performed_actions'] = this.performedActions;
    return json;
  }

  /// Returns a new [PatientDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PatientDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PatientDTO[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PatientDTO[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PatientDTO(
        classification: PatientClassification.fromJson(json[r'classification'])!,
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        location: LocationDTO.fromJson(json[r'location'])!,
        mediaReferences: MediaReferencesDTOInner.listFromJson(json[r'media_references']),
        performedActions: PerformedActionDTO.listFromJson(json[r'performed_actions']),
      );
    }
    return null;
  }

  static List<PatientDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PatientDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PatientDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PatientDTO> mapFromJson(dynamic json) {
    final map = <String, PatientDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PatientDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PatientDTO-objects as value to a dart map
  static Map<String, List<PatientDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PatientDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PatientDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'classification',
    'id',
    'name',
    'location',
    'media_references',
  };
}

