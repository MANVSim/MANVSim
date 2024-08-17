//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class ActionDTOMediaReferencesInner {
  /// Returns a new [ActionDTOMediaReferencesInner] instance.
  ActionDTOMediaReferencesInner({
    required this.mediaType,
    this.title,
    this.text,
    this.mediaReference,
  });

  String mediaType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? text;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mediaReference;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionDTOMediaReferencesInner &&
    other.mediaType == mediaType &&
    other.title == title &&
    other.text == text &&
    other.mediaReference == mediaReference;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mediaType.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (text == null ? 0 : text!.hashCode) +
    (mediaReference == null ? 0 : mediaReference!.hashCode);

  @override
  String toString() => 'ActionDTOMediaReferencesInner[mediaType=$mediaType, title=$title, text=$text, mediaReference=$mediaReference]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'media_type'] = this.mediaType;
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.text != null) {
      json[r'text'] = this.text;
    } else {
      json[r'text'] = null;
    }
    if (this.mediaReference != null) {
      json[r'media_reference'] = this.mediaReference;
    } else {
      json[r'media_reference'] = null;
    }
    return json;
  }

  /// Returns a new [ActionDTOMediaReferencesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActionDTOMediaReferencesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActionDTOMediaReferencesInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActionDTOMediaReferencesInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActionDTOMediaReferencesInner(
        mediaType: mapValueOfType<String>(json, r'media_type')!,
        title: mapValueOfType<String>(json, r'title'),
        text: mapValueOfType<String>(json, r'text'),
        mediaReference: mapValueOfType<String>(json, r'media_reference'),
      );
    }
    return null;
  }

  static List<ActionDTOMediaReferencesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActionDTOMediaReferencesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActionDTOMediaReferencesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActionDTOMediaReferencesInner> mapFromJson(dynamic json) {
    final map = <String, ActionDTOMediaReferencesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActionDTOMediaReferencesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionDTOMediaReferencesInner-objects as value to a dart map
  static Map<String, List<ActionDTOMediaReferencesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActionDTOMediaReferencesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActionDTOMediaReferencesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'media_type',
  };
}

