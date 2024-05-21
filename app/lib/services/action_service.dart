import 'dart:convert';

import 'package:manvsim/models/location.dart';

Future<List<Location>> fetchActions() async {
  String json = demoJson;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((location) => Location.fromJson(location)).toList();
}

Future<String> fetchActionResult(int id) async {
  return "Successful result for $id";
}

const String demoJson = """
[
  {
    "id": 1,
    "name": "Red backpack", 
    "actions": [{
      "id": 1,
      "name": "Scissors",
      "durationInSeconds": 20
    },
    {
      "id": 40,
      "name": "Bandaid",
      "durationInSeconds": 7
    }],
    "locations": [{
      "id": 2,
      "name": "Medication pack",
      "actions": [{
        "id": 2,
        "name": "Pain killer",
        "durationInSeconds": 30
      }],
      "locations": []
      }]
  },
  {
    "id": 3,
    "name": "RTW", 
    "actions": [{
      "id": 3,
      "name": "EKG",
      "durationInSeconds": 120
    }],
    "locations": [{
      "id": 4,
      "name": "Medicine cabinet",
      "actions": [{
        "id": 4,
        "name": "Strong pain killer",
        "durationInSeconds": 50
      }],
      "locations": []
      }]
  }
]""";
