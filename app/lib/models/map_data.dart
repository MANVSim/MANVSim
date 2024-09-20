import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';

typedef PatientPosition = ({
  Offset position,
  int id,
  PatientClass classification
});
typedef LocationPosition = ({Offset position, int id});

class MapData {
  static const defaultSize = Size(1000, 1000);
  static const defaultPadding = 50;

  List<Rect> buildings;
  List<PatientPosition> patientPositions;
  List<LocationPosition> locationPositions;
  Offset lastPosition;
  Size size;

  MapData(this.buildings, this.patientPositions, this.locationPositions,
      this.lastPosition, this.size);

  Rect get rect => Offset.zero & size;

  factory MapData.fromApi(MapDataDTO mapdataDTO) {
    var buildings = mapdataDTO.buildings
        .map((bDTO) => Rect.fromLTWH(
            bDTO.topLeft.x.toDouble(),
            bDTO.topLeft.y.toDouble(),
            bDTO.width.toDouble(),
            bDTO.height.toDouble()))
        .toList();
    var patientPositions = mapdataDTO.patientPositions
        .map((ppDTO) => (
              position: ppDTO.position.toOffset(),
              id: ppDTO.patientId,
              classification:
                  PatientClass.fromString(ppDTO.classification.value)
            ))
        .toList();
    var locationPositions = mapdataDTO.locationPositions
        .map((lpDTO) =>
            (position: lpDTO.position.toOffset(), id: lpDTO.locationId))
        .toList();
    var startingPoint = mapdataDTO.startingPoint?.toOffset();

    var allPoints = [
      ...buildings.map((b) => [b.topLeft, b.bottomRight]).expand((b) => b),
      ...patientPositions.map((pp) => pp.position),
      ...locationPositions.map((lp) => lp.position),
      if (startingPoint != null) startingPoint
    ];
    // TODO: adjust for negative points (for positions in buildings not)
    var size = _calcSize(allPoints);
    startingPoint ??= Offset(
        size.width - defaultPadding / 2, size.height - defaultPadding / 2);
    return MapData(
        buildings, patientPositions, locationPositions, startingPoint, size);
  }

  /// Calculates the needed size based on [points} and [padding].
  /// Uses [defaultSize] if no points are present.
  static Size _calcSize(List<Offset> points, [int padding = defaultPadding]) {
    if (points.isEmpty) return defaultSize;
    var maxPoint = points.reduce((value, element) =>
        Offset(max(value.dx, element.dx), max(value.dy, element.dy)));
    return Size(maxPoint.dx + padding, maxPoint.dy + padding);
  }
}

extension PointDTOToOffset on PointDTO {
  Offset toOffset() => Offset(x.toDouble(), y.toDouble());
}
