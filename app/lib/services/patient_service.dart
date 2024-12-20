import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_list.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/services/location_service.dart';

import '../models/location.dart';
import '../widgets/location/location_screen.dart';
import '../widgets/patient/patient_screen.dart';

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

  static Future<Patient?> refreshPatient(int patientId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientRefreshPost(
            RunPatientArrivePostRequest(patientId: patientId))
        .then((response) => (response?.patient != null
            ? Patient.fromApi((response?.patient)!)
            : null));
  }

  static Future<PatientList> fetchPatientsIDs() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPatientAllIdsGet()
        .then(PatientListExtension.fromApi);
  }

  static Future<void> classifyPatient(
      PatientClass classification, Patient patient) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    await apiService.api.runPatientClassifyPost(RunPatientClassifyPostRequest(
        classification: classification.value, patientId: patient.id));
  }

  /// Navigates to [PatientScreen] and leaves location after.
  static Future goToPatientScreen(int patientId, BuildContext context) {
    return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientScreen(patientId: patientId)))
        .whenComplete(() => LocationService.leaveLocation());
  }

  static void showLocation(Patient patient, BuildContext context) {
    LocationService.leaveLocation();
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LocationScreen(locationId: patient.location.id)))
        .whenComplete(() => PatientService.arriveAtPatient(patient.id));
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
