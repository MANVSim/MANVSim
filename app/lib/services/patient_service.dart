import 'dart:convert';

import 'package:manvsim/models/patient.dart';

Future<List<Patient>> fetchPatientList() async {
  String json = demoJson;//await File("patients.json").readAsString();
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((patient) => Patient.fromJson(patient)).toList();
}

const String demoJson = """
[
  {"id": 1, "description": "Max Mustermann"},
  {"id": 2, "description": "Bernd Beispiel"},
  {"id": 3, "description": "Patient 3"},
  {"id": 4, "description": "Bein fehlt"}
]""";