import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TanUserAuth {
  String? token;
  String? url;
}

class TanUser extends ChangeNotifier {
  static const String preferenceTan = 'user.tan';
  static const String preferenceName = 'user.name';
  static const String preferenceRole = 'user.role';
  static const String preferenceAuthToken = 'user.auth.token';
  static const String preferenceAuthUrl = 'user.auth.url';

  String? tan;
  String? name;
  String? role;

  TanUserAuth auth = TanUserAuth();

  bool isComplete() {
    return tan != null &&
        name != null &&
        role != null &&
        auth.token != null &&
        auth.url != null;
  }

  Future<void> _setPref(
      String key, String? value, SharedPreferences prefs) async {
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();

    await _setPref(preferenceTan, tan, prefs);
    await _setPref(preferenceName, name, prefs);
    await _setPref(preferenceRole, role, prefs);
    await _setPref(preferenceAuthToken, auth.token, prefs);
    await _setPref(preferenceAuthUrl, auth.url, prefs);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    tan = prefs.getString(preferenceTan);
    name = prefs.getString(preferenceName);
    role = prefs.getString(preferenceRole);
    auth.token = prefs.getString(preferenceAuthToken);
    auth.url = prefs.getString(preferenceAuthUrl);

    notifyListeners();
  }
}
