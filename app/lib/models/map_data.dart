import 'dart:math';
import 'dart:ui';

import 'package:manv_api/api.dart';

typedef PatientPosition = ({Offset position, int id});

class MapData {
  static const defaultSize = Size(1000, 1000);
  static const defaultPadding = 50;

  List<Rect> buildings;
  List<PatientPosition> patientsPositions;
  Offset startingPoint;
  Size size;

  // TODO: add locationPositions

  MapData(
      this.buildings, this.patientsPositions, this.startingPoint, this.size);

  factory MapData.fromApi(MapDataDTO mapdataDTO) {
    var buildings = mapdataDTO.buildings
        .map((e) => Rect.fromLTWH(e.topLeft.x.toDouble(),
            e.topLeft.y.toDouble(), e.width.toDouble(), e.height.toDouble()))
        .toList();
    var patientPositions = mapdataDTO.patientPositions
        .map((e) => (position: Offset.zero, id: 0))
        .toList();
    var startingPoint = mapdataDTO.startingPoint != null
        ? Offset(mapdataDTO.startingPoint!.x.toDouble(),
            mapdataDTO.startingPoint!.y.toDouble())
        : Offset.zero;

    var allPoints = [
      ...buildings
          .map((e) => [e.topLeft, e.bottomRight])
          .expand((element) => element),
      ...patientPositions.map((e) => e.position),
      startingPoint
    ];
    // TODO: adjust for negative points
    var size = calcSize(allPoints);
    return MapData(buildings, patientPositions, startingPoint, size);
  }

  static Size calcSize(List<Offset> points) {
    if (points.isEmpty) return defaultSize;
    var maxPoint = points.reduce((value, element) =>
        Offset(max(value.dx, element.dx), max(value.dy, element.dy)));
    return Size(maxPoint.dx + defaultPadding, maxPoint.dy + defaultPadding);
  }
}
