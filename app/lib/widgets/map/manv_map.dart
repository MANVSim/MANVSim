import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/models/offset_ray.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class MANVMap extends StatefulWidget {
  static const tooFarThreshold = 300;

  final MapData mapData;

  /// Provides current position of the player.
  final ValueNotifier<Offset> positionNotifier;

  const MANVMap(this.mapData, this.positionNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _MANVMapState();
}

class _MANVMapState extends State<MANVMap> {
  List<Positioned> messages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.mapData.size.height,
        width: widget.mapData.size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.05,
                repeat: ImageRepeat.repeat,
                image: AssetImage("assets/map_background.jpg")),
            gradient: LinearGradient(
                colors: [Colors.white, Colors.amberAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Stack(
          children: [
            CustomPaint(
                painter:
                    _ShadowPainter(widget.mapData, widget.positionNotifier)),
            ...widget.mapData.buildings.map(rectToPositioned),
            ...getLocationWidgets(context),
            ...getPatientWidgets(context),
            ...messages
          ],
        ));
  }

  List<Positioned> getPatientWidgets(BuildContext context) {
    return widget.mapData.patientPositions
        .map((patientPosition) => Positioned(
              top: patientPosition.position.dy,
              left: patientPosition.position.dx,
              child: IconButton(
                  onPressed: () => _onPatientPressed(patientPosition, context),
                  icon: Icon(Icons.accessibility_new,
                      color: patientPosition.classification.toColor()),
                  iconSize: 50),
            ))
        .toList();
  }

  List<Positioned> getLocationWidgets(BuildContext context) {
    return widget.mapData.locationPositions
        .map((locationPosition) => Positioned(
              top: locationPosition.position.dy,
              left: locationPosition.position.dx,
              child: IconButton(
                  onPressed: () =>
                      _onLocationPressed(locationPosition, context),
                  icon: const Icon(Icons.location_on),
                  iconSize: 50),
            ))
        .toList();
  }

  bool _isTooFar(Offset position) =>
      (position - widget.positionNotifier.value).distance >
      MANVMap.tooFarThreshold;

  void _onPatientPressed(
      PatientPosition patientPosition, BuildContext context) {
    if (_isTooFar(patientPosition.position)) {
      _showTimedMessage(patientPosition.position,
          AppLocalizations.of(context)!.mapPatientTooFar);
    } else {
      PatientService.goToPatientScreen(patientPosition.id, context);
    }
  }

  void _onLocationPressed(
      LocationPosition locationPosition, BuildContext context) {
    if (_isTooFar(locationPosition.position)) {
      _showTimedMessage(locationPosition.position,
          AppLocalizations.of(context)!.mapLocationTooFar);
    } else {
      LocationService.goToLocationScreen(locationPosition.id, context);
    }
  }

  void _showTimedMessage(Offset position, String message,
      [Duration duration = const Duration(seconds: 5)]) {
    var messageWidget = Positioned(
        left: position.dx + 40,
        top: position.dy,
        width: 200,
        child: Card(
          color: Colors.white70,
          child: Text(
            message,
            textScaler: const TextScaler.linear(2),
          ),
        ));
    setState(() {
      messages.add(messageWidget);
    });
    Timer(
        duration,
        () => setState(() {
              messages.remove(messageWidget);
            }));
  }

  Positioned rectToPositioned(Rect rect) {
    return Positioned(
        left: rect.left,
        top: rect.top,
        child: Container(
            width: rect.width, height: rect.height, color: Colors.grey));
  }
}

/// Raw map drawn on a canvas.
/// Draws buildings and their shadows based on [viewerPositionNotifier}.
class _ShadowPainter extends CustomPainter {
  MapData mapData;

  final ValueNotifier<Offset> viewerPositionNotifier;

  _ShadowPainter(this.mapData, this.viewerPositionNotifier)
      : super(repaint: viewerPositionNotifier);

  Offset get viewerPosition => viewerPositionNotifier.value;

  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    for (Rect building in mapData.buildings) {
      for (Path shadow in _getShadow(building, size)) {
        canvas.drawPath(shadow, shadowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ShadowPainter oldDelegate) => true;

  List<Path> _getShadow(Rect building, Size size) {
    return [
      shadowPathForEdge(building.bottomRight, building.bottomLeft),
      shadowPathForEdge(building.bottomLeft, building.topLeft),
      shadowPathForEdge(building.topLeft, building.topRight),
      shadowPathForEdge(building.topRight, building.bottomRight)
    ];
  }

  Path shadowPathForEdge(Offset lineStart, Offset lineEnd) {
    Rect boundingRect = Offset.zero & mapData.size;

    OffsetRay ray = OffsetRay(viewerPosition, viewerPosition - lineStart);
    Offset end = ray.intersectionWithRect(boundingRect)!;

    OffsetRay ray2 = OffsetRay(viewerPosition, viewerPosition - lineEnd);
    Offset end2 = ray2.intersectionWithRect(boundingRect)!;

    var path = [end, lineStart, lineEnd, end2];

    var corners = <Offset>[];
    for (Offset corner in [
      boundingRect.bottomLeft,
      boundingRect.topLeft,
      boundingRect.topRight,
      boundingRect.bottomRight,
    ]) {
      var wideAngle = ray.direction.signedAngleTo(ray2.direction);
      var smallAngle = ray.direction.signedAngleTo(viewerPosition - corner);
      if (wideAngle.sign == smallAngle.sign &&
          smallAngle.abs() < wideAngle.abs()) corners.add(corner);
    }
    corners.sort((a, b) =>
        ((path.last - a).distance - (path.last - b).distance).toInt());
    return Path()..addPolygon(path..addAll(corners), true);
  }
}

extension OffsetAngleTo on Offset {
  double signedAngleTo(Offset other) =>
      toVector3().angleToSigned(other.toVector3(), Vector3(0, 0, 1));
}
