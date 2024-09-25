import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config extends ChangeNotifier {
  String apiUrl = 'https://localhost/api';
  bool showMap = true;
  bool showPatientList = true;
  bool showLocationList = true;
  bool waitScreenIsSkippable = false;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/config/config.json');
    final jsonMap = json.decode(jsonString);

    if (jsonMap['apiUrl'] != null) {
      apiUrl = jsonMap['apiUrl'];
    }
    if (jsonMap['showMap'] != null) {
      showMap = jsonMap['showMap'];
    }
    if (jsonMap['showPatientList'] != null) {
      showPatientList = jsonMap['showPatientList'];
    }
    if (jsonMap['showLocationList'] != null) {
      showLocationList = jsonMap['showLocationList'];
    }
    if (jsonMap['waitScreenIsSkippable'] != null) {
      waitScreenIsSkippable = jsonMap['waitScreenIsSkippable'];
    }
  }
}
