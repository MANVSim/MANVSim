import 'dart:convert';

import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient_action.dart';

Future<List<Location>> fetchLocations() async {
  String json = demoJson;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((location) => Location.fromJson(location)).toList();
}

Future<List<PatientAction>> fetchActions() async {
  await Future.delayed(Duration(seconds: 1)); // TODO
  String json = demoActions;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((action) => PatientAction.fromJson(action)).toList();
}

Future<String> fetchActionResult(int id) async {
  return "Successful result for $id";
}

const String demoActions = """
[
  {
    "id": 1,
    "name": "Pflaster",
    "durationInSeconds": 10
  },
  {
    "id": 2,
    "name": "Klamotten aufschneiden",
    "durationInSeconds": 10
  }
]""";

const String demoJson = """
[
  {
    "id": 1,
    "name": "Red backpack", 
    "resources": [{
      "id": 1,
      "name": "Scissors",
      "quantity": 20
    },
    {
      "id": 40,
      "name": "Bandaid",
      "quantity": 7
    }],
    "locations": [{
      "id": 2,
      "name": "Medication pack",
      "resources": [{
        "id": 2,
        "name": "Pain killer",
        "quantity": 30
      }],
      "locations": []
      }]
  },
  {
    "id": 3,
    "name": "RTW", 
    "resources": [{
      "id": 3,
      "name": "EKG",
      "quantity": 120
    }],
    "locations": [{
      "id": 4,
      "name": "Medicine cabinet",
      "resources": [{
        "id": 4,
        "name": "Strong pain killer",
        "quantity": 50
      }],
      "locations": []
      }]
  }
]""";
