//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;

class LoginPost200Response {
  /// Returns a new [LoginPost200Response] instance.
  LoginPost200Response({
    required this.jwtToken,
    required this.userCreationRequired,
    required this.userName,
    required this.userRole,
  });

  /// JWT-Token, maps game and player
  String jwtToken;

  /// indicates if name for the TAN was already set.
  bool userCreationRequired;

  /// name for the TAN, if userCreationRequired is false. Otherwise empty.
  String userName;

  /// role of the user.
  String userRole;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LoginPost200Response &&
    other.jwtToken == jwtToken &&
    other.userCreationRequired == userCreationRequired &&
    other.userName == userName &&
    other.userRole == userRole;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (jwtToken.hashCode) +
    (userCreationRequired.hashCode) +
    (userName.hashCode) +
    (userRole.hashCode);

  @override
  String toString() => 'LoginPost200Response[jwtToken=$jwtToken, userCreationRequired=$userCreationRequired, userName=$userName, userRole=$userRole]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'jwt_token'] = this.jwtToken;
      json[r'user_creation_required'] = this.userCreationRequired;
      json[r'user_name'] = this.userName;
      json[r'user_role'] = this.userRole;
    return json;
  }

  /// Returns a new [LoginPost200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LoginPost200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LoginPost200Response[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LoginPost200Response[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LoginPost200Response(
        jwtToken: mapValueOfType<String>(json, r'jwt_token')!,
        userCreationRequired: mapValueOfType<bool>(json, r'user_creation_required')!,
        userName: mapValueOfType<String>(json, r'user_name')!,
        userRole: mapValueOfType<String>(json, r'user_role')!,
      );
    }
    return null;
  }

  static List<LoginPost200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LoginPost200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LoginPost200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LoginPost200Response> mapFromJson(dynamic json) {
    final map = <String, LoginPost200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LoginPost200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LoginPost200Response-objects as value to a dart map
  static Map<String, List<LoginPost200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LoginPost200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LoginPost200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'jwt_token',
    'user_creation_required',
    'user_name',
    'user_role',
  };
}

