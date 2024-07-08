import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_location.dart';
import 'package:manvsim/services/api_service.dart';
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

class PatientService {
  static Future<PatientLocation> arriveAtPatient(int patientId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientArrivePost(RunPatientArrivePostRequest(patientId: patientId))
        .then((value) => (
              Patient.fromApi((value?.patient)!),
              Location.fromApi((value?.playerLocation)!)
            ));
  }

  static Future<List<int>?> fetchPatientsIDs() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientAllIdsGet()
        .then((value) => value?.tans);
  }
}

const String demoJson = """
[
  {"id": 1, "name": "Max Mustermann", "injuries": "Beinverletzung"},
  {"id": 2, "name": "Bernd Beispiel", "injuries": "offene Blutung"},
  {"id": 3, "name": "Patient 3", "injuries": "SHT"},
  {"id": 4, "name": "Ronald Lyons", "injuries": "Bein fehlt"}
]""";
