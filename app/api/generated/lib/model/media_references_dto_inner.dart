//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class MediaReferencesDTOInner {
  /// Returns a new [MediaReferencesDTOInner] instance.
  MediaReferencesDTOInner({
    this.mediaReference,
    required this.mediaType,
    this.text,
    this.title,
  });

  /// The path or URL to the media resource.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mediaReference;

  /// The type of media referenced.
  MediaReferencesDTOInnerMediaTypeEnum mediaType;

  /// Optional text associated with the media reference.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? text;

  /// Optional title associated with the media reference.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MediaReferencesDTOInner &&
    other.mediaReference == mediaReference &&
    other.mediaType == mediaType &&
    other.text == text &&
    other.title == title;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mediaReference == null ? 0 : mediaReference!.hashCode) +
    (mediaType.hashCode) +
    (text == null ? 0 : text!.hashCode) +
    (title == null ? 0 : title!.hashCode);

  @override
  String toString() => 'MediaReferencesDTOInner[mediaReference=$mediaReference, mediaType=$mediaType, text=$text, title=$title]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.mediaReference != null) {
      json[r'media_reference'] = this.mediaReference;
    } else {
      json[r'media_reference'] = null;
    }
      json[r'media_type'] = this.mediaType;
    if (this.text != null) {
      json[r'text'] = this.text;
    } else {
      json[r'text'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    return json;
  }

  /// Returns a new [MediaReferencesDTOInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MediaReferencesDTOInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MediaReferencesDTOInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MediaReferencesDTOInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MediaReferencesDTOInner(
        mediaReference: mapValueOfType<String>(json, r'media_reference'),
        mediaType: MediaReferencesDTOInnerMediaTypeEnum.fromJson(json[r'media_type'])!,
        text: mapValueOfType<String>(json, r'text'),
        title: mapValueOfType<String>(json, r'title'),
      );
    }
    return null;
  }

  static List<MediaReferencesDTOInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MediaReferencesDTOInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MediaReferencesDTOInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MediaReferencesDTOInner> mapFromJson(dynamic json) {
    final map = <String, MediaReferencesDTOInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MediaReferencesDTOInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MediaReferencesDTOInner-objects as value to a dart map
  static Map<String, List<MediaReferencesDTOInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MediaReferencesDTOInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MediaReferencesDTOInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'media_type',
  };
}

/// The type of media referenced.
class MediaReferencesDTOInnerMediaTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const MediaReferencesDTOInnerMediaTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const IMAGE = MediaReferencesDTOInnerMediaTypeEnum._(r'IMAGE');
  static const VIDEO = MediaReferencesDTOInnerMediaTypeEnum._(r'VIDEO');
  static const TEXT = MediaReferencesDTOInnerMediaTypeEnum._(r'TEXT');
  static const AUDIO = MediaReferencesDTOInnerMediaTypeEnum._(r'AUDIO');

  /// List of all possible values in this [enum][MediaReferencesDTOInnerMediaTypeEnum].
  static const values = <MediaReferencesDTOInnerMediaTypeEnum>[
    IMAGE,
    VIDEO,
    TEXT,
    AUDIO,
  ];

  static MediaReferencesDTOInnerMediaTypeEnum? fromJson(dynamic value) => MediaReferencesDTOInnerMediaTypeEnumTypeTransformer().decode(value);

  static List<MediaReferencesDTOInnerMediaTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MediaReferencesDTOInnerMediaTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MediaReferencesDTOInnerMediaTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MediaReferencesDTOInnerMediaTypeEnum] to String,
/// and [decode] dynamic data back to [MediaReferencesDTOInnerMediaTypeEnum].
class MediaReferencesDTOInnerMediaTypeEnumTypeTransformer {
  factory MediaReferencesDTOInnerMediaTypeEnumTypeTransformer() => _instance ??= const MediaReferencesDTOInnerMediaTypeEnumTypeTransformer._();

  const MediaReferencesDTOInnerMediaTypeEnumTypeTransformer._();

  String encode(MediaReferencesDTOInnerMediaTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MediaReferencesDTOInnerMediaTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MediaReferencesDTOInnerMediaTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'IMAGE': return MediaReferencesDTOInnerMediaTypeEnum.IMAGE;
        case r'VIDEO': return MediaReferencesDTOInnerMediaTypeEnum.VIDEO;
        case r'TEXT': return MediaReferencesDTOInnerMediaTypeEnum.TEXT;
        case r'AUDIO': return MediaReferencesDTOInnerMediaTypeEnum.AUDIO;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MediaReferencesDTOInnerMediaTypeEnumTypeTransformer] instance.
  static MediaReferencesDTOInnerMediaTypeEnumTypeTransformer? _instance;
}


