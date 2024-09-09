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
    return const [
      Rect.fromLTRB(100, 120, 210, 240),
      Rect.fromLTRB(100, 730, 300, 980),
      Rect.fromLTRB(300, 150, 910, 240),
      Rect.fromLTRB(700, 750, 910, 930),
      Rect.fromLTRB(340, 330, 520, 530)
    ];
  }
}
