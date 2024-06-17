//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class NotificationsGet200ResponseNotificationsInner {
  /// Returns a new [NotificationsGet200ResponseNotificationsInner] instance.
  NotificationsGet200ResponseNotificationsInner({
    this.header,
    this.message,
    this.timestamp,
  });

  /// header of the notification.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? header;

  /// The message itself.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  /// timestamp in ISO 8601 Format.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? timestamp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationsGet200ResponseNotificationsInner &&
    other.header == header &&
    other.message == message &&
    other.timestamp == timestamp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (header == null ? 0 : header!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (timestamp == null ? 0 : timestamp!.hashCode);

  @override
  String toString() => 'NotificationsGet200ResponseNotificationsInner[header=$header, message=$message, timestamp=$timestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.header != null) {
      json[r'header'] = this.header;
    } else {
      json[r'header'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.timestamp != null) {
      json[r'timestamp'] = this.timestamp!.toUtc().toIso8601String();
    } else {
      json[r'timestamp'] = null;
    }
    return json;
  }

  /// Returns a new [NotificationsGet200ResponseNotificationsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationsGet200ResponseNotificationsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "NotificationsGet200ResponseNotificationsInner[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "NotificationsGet200ResponseNotificationsInner[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NotificationsGet200ResponseNotificationsInner(
        header: mapValueOfType<String>(json, r'header'),
        message: mapValueOfType<String>(json, r'message'),
        timestamp: mapDateTime(json, r'timestamp', r''),
      );
    }
    return null;
  }

  static List<NotificationsGet200ResponseNotificationsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationsGet200ResponseNotificationsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationsGet200ResponseNotificationsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationsGet200ResponseNotificationsInner> mapFromJson(dynamic json) {
    final map = <String, NotificationsGet200ResponseNotificationsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationsGet200ResponseNotificationsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationsGet200ResponseNotificationsInner-objects as value to a dart map
  static Map<String, List<NotificationsGet200ResponseNotificationsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationsGet200ResponseNotificationsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationsGet200ResponseNotificationsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

