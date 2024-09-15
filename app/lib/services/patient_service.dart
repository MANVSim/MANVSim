import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_list.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/services/location_service.dart';

import '../models/location.dart';
import '../screens/patient_screen.dart';

/// Provides methods to manage [Patient].
///
/// Doesn't offer error handling.
class PatientService {
  static Future<Patient?> arriveAtPatient(int patientId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientArrivePost(RunPatientArrivePostRequest(patientId: patientId))
        .then((response) => (response?.patient != null
            ? Patient.fromApi((response?.patient)!)
            : null));
  }

  static Future<PatientList> fetchPatientsIDs() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientAllIdsGet()
        .then((response) => PatientListExtension.fromApi(response));
  }

  /// Navigates to [PatientScreen] and leaves location after.
  static void goToPatientScreen(int patientId, BuildContext context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientScreen(patientId: patientId)))
        .whenComplete(() => LocationService.leaveLocation());
  }

  static Future<Patient?> movePatient(Patient patient, Location moveTo) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runActionPerformMovePatientPost(RunActionPerformMovePatientPostRequest(
            patientId: patient.id, newLocationId: moveTo.id))
        .then((response) => (response?.patient != null
            ? Patient.fromApi((response?.patient)!)
            : null));
  }
}
