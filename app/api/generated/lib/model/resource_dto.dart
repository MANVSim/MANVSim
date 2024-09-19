//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class ResourceDTO {
  /// Returns a new [ResourceDTO] instance.
  ResourceDTO({
    this.mediaReferences = const [],
    required this.id,
    required this.name,
    required this.quantity,
  });

  List<MediaReferencesDTOInner> mediaReferences;

  int id;

  String name;

  int quantity;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ResourceDTO &&
    _deepEquality.equals(other.mediaReferences, mediaReferences) &&
    other.id == id &&
    other.name == name &&
    other.quantity == quantity;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mediaReferences.hashCode) +
    (id.hashCode) +
    (name.hashCode) +
    (quantity.hashCode);

  @override
  String toString() => 'ResourceDTO[mediaReferences=$mediaReferences, id=$id, name=$name, quantity=$quantity]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'media_references'] = this.mediaReferences;
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'quantity'] = this.quantity;
    return json;
  }

  /// Returns a new [ResourceDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ResourceDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ResourceDTO[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ResourceDTO[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ResourceDTO(
        mediaReferences: MediaReferencesDTOInner.listFromJson(json[r'media_references']),
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        quantity: mapValueOfType<int>(json, r'quantity')!,
      );
    }
    return null;
  }

  static List<ResourceDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ResourceDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResourceDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResourceDTO> mapFromJson(dynamic json) {
    final map = <String, ResourceDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ResourceDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResourceDTO-objects as value to a dart map
  static Map<String, List<ResourceDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ResourceDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResourceDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'quantity',
  };
}

