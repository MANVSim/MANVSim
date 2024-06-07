import 'dart:convert';

import 'package:manvsim/models/location.dart';

Future<List<Location>> fetchLocations() async {
  await Future.delayed(const Duration(milliseconds: 500));
  String json = demoLocations;
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((location) => Location.fromJson(location)).toList();
}

const String demoLocations = """
[
  {
    "id": 1,
    "name": "Roter Rucksack",
    "resources": [
      {
        "id": 1,
        "name": "Schere",
        "quantity": 20
      },
      {
        "id": 40,
        "name": "Pflaster",
        "quantity": 7
      }
    ],
    "locations": [
      {
        "id": 2,
        "name": "Medikamententasche",
        "resources": [
          {
            "id": 2,
            "name": "Schmerzmittel",
            "quantity": 30
          }
        ],
        "locations": [

        ]
      }
    ]
  },
  {
    "id": 3,
    "name": "RTW",
    "resources": [
      {
        "id": 3,
        "name": "EKG",
        "quantity": 120
      }
    ],
    "locations": [
      {
        "id": 4,
        "name": "Medizinschrank",
        "resources": [
          {
            "id": 4,
            "name": "Starkes Schmerzmittel",
            "quantity": 50
          }
        ],
        "locations": [

        ]
      }
    ]
  }
]""";