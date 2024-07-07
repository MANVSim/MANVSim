import 'dart:convert';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/services/api_service.dart';

class ActionService {
  // TODO error handling?
  static Future<List<PatientAction>?> fetchActions() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runActionAllGet()
        .then((value) => value?.map((e) => PatientAction.fromApi(e)).toList());
  }

  static Future<String?> performAction(int patientId,
      int actionId, List<int> resourceIds) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runActionPerformPost(RunActionPerformPostRequest(
            actionId: actionId, patientId: patientId, resources: resourceIds))
        .then((value) => value?.performedActionId);
  }

  static Future<String?> fetchActionResult(int patientId, String performedActionId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runActionPerformResultGet(performedActionId, patientId);
  }
}

Future<List<PatientAction>> fetchActions() async {
  await Future.delayed(const Duration(seconds: 1));
  String json = demoActions;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((action) => PatientAction.fromJson(action)).toList();
}

Future<String> fetchActionResult(int performedActionId) async {
  await Future.delayed(const Duration(seconds: 1));
  return "Successful result for $performedActionId";
}

Future<int> performAction(int actionId, List<int> resourceIds) async {
  await Future.delayed(const Duration(seconds: 1));
  if (Random().nextBool() && Random().nextBool()) throw Error();
  return 1;
}

const String demoActions = """
[
  {
    "id": 1,
    "name": "Pflaster anbringen",
    "durationInSeconds": 10,
    "resourceNamesNeeded": [
      "Pflaster"
    ]
  },
  {
    "id": 2,
    "name": "Klamotten aufschneiden",
    "durationInSeconds": 4,
    "resourceNamesNeeded": [
      "Schere"
    ]
  },
  {
    "id": 3,
    "name": "Schmerzmittel verabreichen",
    "durationInSeconds": 20,
    "resourceNamesNeeded": [
      "Schmerzmittel"
    ]
  },
  {
    "id": 4,
    "name": "Sollte nicht möglich sein",
    "durationInSeconds": 20,
    "resourceNamesNeeded": [
      "Unbekannte Resource"
    ]
  }
]""";
