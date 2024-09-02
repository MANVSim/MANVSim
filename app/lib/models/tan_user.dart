import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TanUserAuth {
  String? token;
  String? url;
}


class TanUser extends ChangeNotifier{
  static const String PREF_TAN = 'user.tan';
  static const String PREF_NAME = 'user.name';
  static const String PREF_ROLE = 'user.role';
  static const String PREF_AUTH_TOKEN = 'user.auth.token';
  static const String PREF_AUTH_URL = 'user.auth.url';

  String? tan;
  String? name;
  String? role;

  TanUserAuth auth = TanUserAuth();

  bool isComplete() {
    return tan != null && name != null && role != null &&
        auth.token != null && auth.url != null;
  }

  Future<void> _setPref(String key, String? value, SharedPreferences prefs) async {
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();

    await _setPref(PREF_TAN, tan, prefs);
    await _setPref(PREF_NAME, name, prefs);
    await _setPref(PREF_ROLE, role, prefs);
    await _setPref(PREF_AUTH_TOKEN, auth.token, prefs);
    await _setPref(PREF_AUTH_URL, auth.url, prefs);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    tan = prefs.getString(PREF_TAN);
    name = prefs.getString(PREF_NAME);
    role = prefs.getString(PREF_ROLE);
    auth.token = prefs.getString(PREF_AUTH_TOKEN);
    auth.url = prefs.getString(PREF_AUTH_URL);

    notifyListeners();
  }
}
