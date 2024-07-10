import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_location.dart';
import 'package:manvsim/services/api_service.dart';

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
