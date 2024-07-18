import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/api_service.dart';

/// Provides methods to manage [PatientAction].
///
/// Doesn't offer error handling.
class ActionService {
  static Future<List<PatientAction>> fetchActions() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api.runActionAllGet().then((response) =>
        response?.actions.map((e) => PatientAction.fromApi(e)).toList() ?? []);
  }

  static Future<String?> performAction(
      int patientId, int actionId, List<int> resourceIds) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runActionPerformPost(RunActionPerformPostRequest(
            actionId: actionId, patientId: patientId, resources: resourceIds))
        .then((response) => response?.performedActionId);
  }

  static Future<ConditionPatient?> fetchActionResult(
      int patientId, String performedActionId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runActionPerformResultGet(performedActionId, patientId)
        .then((response) => response?.patient != null
            ? ((response?.conditions)!, Patient.fromApi((response?.patient)!))
            : null);
  }
}
