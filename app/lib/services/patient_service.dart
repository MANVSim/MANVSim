import 'dart:convert';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_location.dart';
import 'package:manvsim/services/location_service.dart';

@Deprecated("Should be replaced by fetchAllPatientIds.")
Future<List<Patient>> fetchPatientList() async {
  await Future.delayed(const Duration(seconds: 1));
  String json = demoJson;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((patient) => Patient.fromJson(patient)).toList();
}

Future<PatientLocation> arriveAtPatient(int id) async {
  var locations = await fetchLocations();
  return fetchPatientList().then(
      (patientList) => (patientList[id % patientList.length], locations[0]));
}

const String demoJson = """
[
  {"id": 1, "name": "Max Mustermann", "injuries": "Beinverletzung"},
  {"id": 2, "name": "Bernd Beispiel", "injuries": "offene Blutung"},
  {"id": 3, "name": "Patient 3", "injuries": "SHT"},
  {"id": 4, "name": "Ronald Lyons", "injuries": "Bein fehlt"}
]""";