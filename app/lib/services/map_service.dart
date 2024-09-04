import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/patient_map.dart';

/// Provides methods to manage map data and positions.
///
/// Doesn't offer error handling.
class MapService {
  static Future<List<PatientPosition>?> fetchPatientPositions() {
    var rnd = Random();
    return PatientService.fetchPatientsIDs()
        .then((idList) => [...?idList, ...?idList]
            .map((id) => (
                  position: Point<double>(rnd.nextDouble() * PatientMap.width,
                      rnd.nextDouble() * PatientMap.height),
                  id: id
                ))
            .toList());
  }

  static Future<List<Rect>> fetchBuildings() async {
    return [
      Rect.fromLTRB(100, 100, 200, 200),
      Rect.fromLTRB(300, 300, 500, 500)
    ];
  }
}
