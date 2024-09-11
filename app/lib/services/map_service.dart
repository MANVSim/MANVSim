import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/services/patient_service.dart';

/// Provides methods to manage map data and positions.
///
/// Doesn't offer error handling.
class MapService {
  static Future<List<PatientPosition>?> fetchPatientPositions() {
    var rnd = Random();
    return PatientService.fetchPatientsIDs()
        .then((idList) => [...?idList, ...?idList]
            .map((id) => (
                  position: Offset(rnd.nextDouble() * MapData.defaultSize.width,
                      rnd.nextDouble() * MapData.defaultSize.height),
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

  static Future<MapData?> fetchMapData() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runMapdataGet()
        .then((value) => value != null ? MapData.fromApi(value) : null);
  }
}
