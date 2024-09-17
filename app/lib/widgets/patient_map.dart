import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/models/offset_ray.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class PatientMap extends StatefulWidget {
  final MapData mapData;

  /// Provides current position of the player.
  final ValueNotifier<Offset> positionNotifier;

  const PatientMap(this.mapData, this.positionNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _PatientMapState();
}

class _PatientMapState extends State<PatientMap> {
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
            ...getPatientWidgets(context),
            ...messages
          ],
        ));
  }

  List<Positioned> getPatientWidgets(BuildContext context) {
    return widget.mapData.patientsPositions
        .map((patientPosition) => Positioned(
              top: patientPosition.position.dy,
              left: patientPosition.position.dx,
              child: IconButton(
                  onPressed: () => _onPatientPressed(patientPosition, context),
                  icon: const Icon(Icons.accessibility_new),
                  iconSize: 50),
            ))
        .toList();
  }

  void _onPatientPressed(
      PatientPosition patientPosition, BuildContext context) {
    if ((patientPosition.position - widget.positionNotifier.value).distance <=
        300) {
      PatientService.goToPatientScreen(patientPosition.id, context);
      return;
    }
    var message = Positioned(
        left: patientPosition.position.dx + 40,
        top: patientPosition.position.dy,
        width: 200,
        child: Card(
          child: Text(
            AppLocalizations.of(context)!.mapPatientTooFar,
            textScaler: const TextScaler.linear(2),
          ),
        ));
    setState(() {
      messages.add(message);
    });
    Timer(
        const Duration(seconds: 5),
        () => setState(() {
              messages.remove(message);
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
