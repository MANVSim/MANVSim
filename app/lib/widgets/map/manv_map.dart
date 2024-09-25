import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/utils/custom_transformation_controller.dart';
import 'package:manvsim/utils/offset_ray.dart';

class MANVMap extends StatefulWidget {
  static final buildingColor = Colors.grey.shade400;
  static const tooFarThreshold = 300;

  /// The [MapData] with which this map is drawn.
  final MapData mapData;

  /// The Controller controlling the overlays transformation of the map.
  /// Used to display text in the correct orientation.
  final CustomTransformationController? transformationController;

  /// Provides current position of the player.
  /// Used to draw shadows of obstacles.
  final ValueNotifier<Offset> positionNotifier;

  /// To be called when navigating to a new Page.
  final Function onPageLeave;
  final Function onPageBack;

  const MANVMap(
      {required this.mapData,
      required this.positionNotifier,
      this.transformationController,
      required this.onPageLeave,
      required this.onPageBack,
      super.key});

  @override
  State<StatefulWidget> createState() => _MANVMapState();
}

class _MANVMapState extends State<MANVMap> {
  List<Positioned> messages = [];

  List<Positioned> _getPatientWidgets() {
    return widget.mapData.patientPositions
        .map((patientPosition) => Positioned(
              top: patientPosition.position.dy,
              left: patientPosition.position.dx,
              child: IconButton(
                  onPressed: () => _onButtonPressed(
                      patientPosition.position,
                      () => PatientService.goToPatientScreen(
                          patientPosition.id, context),
                      AppLocalizations.of(context)!.mapPatientTooFar),
                  icon: Icon(
                    size: 50,
                    opticalSize: 50,
                    shadows: const [
                      Shadow(
                          color: Colors.black45,
                          blurRadius: 1,
                          offset: Offset(-2, -2))
                    ],
                    Icons.accessibility_new,
                    color: patientPosition.classification.color,
                  )),
            ))
        .toList();
  }

  List<Positioned> _getLocationWidgets() {
    return widget.mapData.locationPositions
        .map((locationPosition) => Positioned(
              top: locationPosition.position.dy,
              left: locationPosition.position.dx,
              child: IconButton(
                  onPressed: () => _onButtonPressed(
                      locationPosition.position,
                      () => LocationService.goToLocationScreen(
                          locationPosition.id, context),
                      AppLocalizations.of(context)!.mapLocationTooFar),
                  icon: const Icon(
                    ManvIcons.location,
                    color: Colors.black54,
                  ),
                  iconSize: 35),
            ))
        .toList();
  }

  bool _isTooFar(Offset position) =>
      (position - widget.positionNotifier.value).distance >
      MANVMap.tooFarThreshold;

  void _onButtonPressed(Offset position, Future Function() navigationCallback,
      String tooFarMessage) {
    if (_isTooFar(position)) {
      _showTimedMessage(position, tooFarMessage);
    } else {
      widget.onPageLeave();
      navigationCallback().whenComplete(() => widget.onPageBack());
    }
  }

  void _showTimedMessage(Offset position, String message,
      [Duration duration = const Duration(seconds: 5)]) {
    var messageWidget = Positioned(
        left: position.dx + 40,
        top: position.dy,
        width: 200,
        child: Transform(
            transform: Matrix4.rotationZ(
                widget.transformationController?.currentRotation ?? 0)
              ..scale(
                  0.5 / (widget.transformationController?.currentScale ?? 1)),
            child: Card(
              color: Colors.white70,
              child: Text(
                message,
                textScaler: const TextScaler.linear(2),
              ),
            )));
    setState(() {
      messages.add(messageWidget);
    });
    Timer(
        duration,
        () => setState(() {
              messages.remove(messageWidget);
            }));
  }

  /// Converts a building from a model to a UI widget.
  Positioned _rectToPositioned(Rect rect) {
    return Positioned(
        left: rect.left,
        top: rect.top,
        child: Container(
            width: rect.width,
            height: rect.height,
            color: MANVMap.buildingColor));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.mapData.size.height,
        width: widget.mapData.size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.02,
                repeat: ImageRepeat.repeat,
                image: AssetImage("assets/map_background.jpg")),
            color: Color(0xffffeb9f)),
        child: Stack(
          children: [
            ..._getLocationWidgets(),
            ..._getPatientWidgets(),
            CustomPaint(
                painter:
                    _ShadowPainter(widget.mapData, widget.positionNotifier)),
            ...widget.mapData.buildings.map(_rectToPositioned),
            ...messages
          ],
        ));
  }
}

typedef _ShadowEdge = ({Offset start, Offset end, OffsetRay ray});

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
    // TODO: instead of drawing shadows for all edges figure out which two corners form the biggest shadow
    var edges = [
      building.bottomRight,
      building.bottomLeft,
      building.topLeft,
      building.topRight
    ].map(_calcShadowEdge).toList();

    return [
      _shadowPathForEdges(edges[0], edges[1]),
      _shadowPathForEdges(edges[1], edges[2]),
      _shadowPathForEdges(edges[2], edges[3]),
      _shadowPathForEdges(edges[3], edges[0]),
    ];
  }

  Path _shadowPathForEdges(_ShadowEdge edge, _ShadowEdge edge2) {
    Rect boundingRect = mapData.rect;

    var path = [edge.end, edge.start, edge2.start, edge2.end];

    var corners = <Offset>[];
    for (Offset corner in [
      boundingRect.bottomLeft,
      boundingRect.topLeft,
      boundingRect.topRight,
      boundingRect.bottomRight,
    ]) {
      var wideAngle = edge.ray.direction.signedAngleTo(edge2.ray.direction);
      var smallAngle =
          edge.ray.direction.signedAngleTo(viewerPosition - corner);
      if (wideAngle.sign == smallAngle.sign &&
          smallAngle.abs() < wideAngle.abs()) corners.add(corner);
    }
    corners.sort((a, b) =>
        ((path.last - a).distance - (path.last - b).distance).toInt());
    return Path()..addPolygon(path..addAll(corners), true);
  }

  _ShadowEdge _calcShadowEdge(Offset start) {
    OffsetRay ray = OffsetRay(viewerPosition, viewerPosition - start);
    Offset end = ray.intersectionWithRect(mapData.rect)!;
    return (start: start, end: end, ray: ray);
  }
}
