import 'dart:convert';
import 'dart:math';

import 'package:manvsim/models/patient_action.dart';

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
