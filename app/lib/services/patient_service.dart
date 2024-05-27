import 'dart:convert';

import 'package:manvsim/models/patient.dart';

Future<List<Patient>> fetchPatientList() async {
  await Future.delayed(Duration(seconds: 1));
  String json = demoJson;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((patient) => Patient.fromJson(patient)).toList();
}

Future<Patient> fetchPatient(int id) async {
  return fetchPatientList().then((patientList) => patientList[0]);
}

const String demoJson = """
[
  {"id": 1, "name": "Max Mustermann", "injuries": "Beinverletzung"},
  {"id": 2, "name": "Bernd Beispiel", "injuries": "offene Blutung"},
  {"id": 3, "name": "Patient 3", "injuries": "SHT"},
  {"id": 4, "name": "Ronald Lyons", "injuries": "Bein fehlt"}
]""";