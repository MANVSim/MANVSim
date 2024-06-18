//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class LoginPostRequest {
  /// Returns a new [LoginPostRequest] instance.
  LoginPostRequest({
    this.TAN,
  });

  /// User TAN
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? TAN;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LoginPostRequest &&
    other.TAN == TAN;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (TAN == null ? 0 : TAN!.hashCode);

  @override
  String toString() => 'LoginPostRequest[TAN=$TAN]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.TAN != null) {
      json[r'TAN'] = this.TAN;
    } else {
      json[r'TAN'] = null;
    }
    return json;
  }

  /// Returns a new [LoginPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LoginPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LoginPostRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LoginPostRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LoginPostRequest(
        TAN: mapValueOfType<String>(json, r'TAN'),
      );
    }
    return null;
  }

  static List<LoginPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LoginPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LoginPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LoginPostRequest> mapFromJson(dynamic json) {
    final map = <String, LoginPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LoginPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LoginPostRequest-objects as value to a dart map
  static Map<String, List<LoginPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LoginPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LoginPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}
