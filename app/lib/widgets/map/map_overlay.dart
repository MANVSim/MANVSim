import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/utils/custom_transformation_controller.dart';
import 'package:manvsim/utils/offset_ray.dart';
import 'package:manvsim/widgets/map/manv_map.dart';

/// The possible Positions of the player on the Viewport.
enum MapOverlayViewerPositions {
  center(alignment: Alignment.center),
  bottomCenter(alignment: Alignment(0.0, 0.9));

  const MapOverlayViewerPositions({required this.alignment});

  final Alignment alignment;
}

class PatientMapOverlay extends StatefulWidget {
  const PatientMapOverlay(
      {required this.mapData,
      this.positionType = MapOverlayViewerPositions.bottomCenter,
      required this.refreshData,
      super.key});

  final MapData mapData;

  /// Where the viewer is positioned on the Viewport.
  final MapOverlayViewerPositions positionType;

  final Function refreshData;

  @override
  State<StatefulWidget> createState() => _PatientMapOverlayState();
}

class _PatientMapOverlayState extends State<PatientMapOverlay>
    with SingleTickerProviderStateMixin {
  static final backgroundColor = Colors.grey.shade700;

  /// Size of the viewport.
  final Size viewportSize = const Size(300, 400);

  /// Provides the position of the player.
  late ValueNotifier<Offset> positionNotifier;

  /// Last tapped position on overlay. Used to ignore small changes.
  Offset lastTapped = Offset.zero;

  /// Controller for view transformations (using [Matrix4]).
  late final CustomTransformationController _transformationController;

  /// Animation "moving the center".
  Animation<Offset> _translationAnimation =
      const AlwaysStoppedAnimation(Offset.zero);
  late final AnimationController _animationController;

  /// Player position on the viewport.
  Offset get positionOnViewport =>
      widget.positionType.alignment.withinRect(boundingBox);

  Rect get boundingBox => Offset.zero & viewportSize;
  Rect get mapRect => Offset.zero & widget.mapData.size;
  List<Rect> get buildings => widget.mapData.buildings;

  Offset toScene(Offset pointOnViewport) =>
      _transformationController.toScene(pointOnViewport);

  Offset targetPositionToTranslation(Offset targetPosition) =>
      -(targetPosition - positionOnViewport);

  @override
  void initState() {
    super.initState();
    positionNotifier = ValueNotifier(widget.mapData.lastPosition);
    _transformationController =
        CustomTransformationController(positionOnViewport)
          ..setTranslation(targetPositionToTranslation(positionNotifier.value));
    _animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// When [direction] is true, goes max distance in that direction.
  void _onNewTargetOffset(Offset tappedOnViewport, [bool direction = false]) {
    if (direction) {
      if ((lastTapped - tappedOnViewport).distance < 20) {
        return;
      }
      Offset direction = positionOnViewport - tappedOnViewport;
      tappedOnViewport = positionOnViewport - (direction * 50);
    }
    lastTapped = tappedOnViewport;
    _onNewDirection(toScene(tappedOnViewport));
  }

  /// Start animation moving the middle to the edge.
  void _onNewDirection(Offset tappedOnScene) {
    Offset viewerOnScene = positionNotifier.value;
    Offset targetOnScene = _getMovementTarget(viewerOnScene, tappedOnScene);
    _onMoveEnd();
    _translationAnimation = Tween<Offset>(
            begin: _transformationController.currentTranslation,
            end: targetPositionToTranslation(targetOnScene))
        .animate(_animationController)
      ..addListener(_onAnimate);
    double distance = (targetOnScene - viewerOnScene).distance;
    _animationController.duration =
        Duration(milliseconds: max(distance.toInt() * 10, 1000));
    _animationController.forward();
  }

  void _onMoveEnd() {
    _translationAnimation.removeListener(_onAnimate);
    _animationController.reset();
  }

  /// Translates the View during the animation.
  void _onAnimate() {
    _transformationController.setTranslation(_translationAnimation.value);
    positionNotifier.value = toScene(positionOnViewport);
  }

  /// Uses vector math to determine where the path hits an obstacle or the edge.
  Offset _getMovementTarget(Offset origin, Offset target) {
    OffsetRay dirRay = OffsetRay(origin, origin - target);
    double alternativeTargetDistance = [...buildings, mapRect]
        .map(dirRay.intersectsWithRect)
        .whereType<double>() // Filter not intersecting
        .where((element) => element < 0) // Filter going opposite direction
        .map((distance) => distance * 0.95) // Don't go all the way into an edge
        .reduce(max);
    Offset alternativeTarget = dirRay.at(alternativeTargetDistance);
    return (origin - alternativeTarget).distance < (origin - target).distance
        ? alternativeTarget
        : target;
  }

  Widget _buildControls() {
    return Card(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        IconButton(
            onPressed: () => _transformationController.tilt(-pi / 12),
            icon: const Icon(Icons.arrow_drop_down)),
        IconButton(
            onPressed: () => _transformationController.tilt(pi / 12),
            icon: const Icon(Icons.arrow_drop_up)),
      ]),
      Column(children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () => _transformationController.rotate(-pi / 12),
              icon: const Icon(Icons.rotate_left)),
          IconButton(
              onPressed: () => _onNewDirection(toScene(
                  positionOnViewport.translate(0, -viewportSize.height))),
              icon: const Icon(Icons.arrow_circle_up)),
          IconButton(
              onPressed: () => _transformationController.rotate(pi / 12),
              icon: const Icon(Icons.rotate_right)),
        ]),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => _onNewDirection(toScene(
                    positionOnViewport.translate(-viewportSize.width, 0))),
                icon: const Icon(Icons.arrow_circle_left_outlined)),
            IconButton(
                onPressed: _onMoveEnd, icon: const Icon(Icons.stop_circle)),
            IconButton(
                onPressed: () => _onNewDirection(toScene(
                    positionOnViewport.translate(viewportSize.width, 0))),
                icon: const Icon(Icons.arrow_circle_right_outlined)),
          ],
        )
      ]),
      Column(children: [
        IconButton(
            onPressed: () => _transformationController.scale(2),
            icon: const Icon(Icons.zoom_in)),
        IconButton(
            onPressed: () => _transformationController.scale(0.5),
            icon: const Icon(Icons.zoom_out)),
      ])
    ]));
  }

  void _onPageLeave() {
    _animationController.stop();
  }

  Widget _buildMapViewport() {
    MANVMap manvMap = MANVMap(
      mapData: widget.mapData,
      positionNotifier: positionNotifier,
      transformationController: _transformationController,
      onPageLeave: _onPageLeave,
      onPageBack: widget.refreshData,
    );
    return GestureDetector(
      onLongPressStart: (details) =>
          _onNewTargetOffset(details.localPosition, true),
      onLongPressUp: _onMoveEnd,
      onLongPressMoveUpdate: (details) =>
          _onNewTargetOffset(details.localPosition, true),
      onTapUp: (details) => _onNewTargetOffset(details.localPosition),
      child: Container(
          width: viewportSize.width,
          height: viewportSize.height,
          decoration: BoxDecoration(
              border: Border.all(width: 3),
              // Background for empty space:
              color: backgroundColor),
          child: ClipRect(
              clipBehavior: Clip.hardEdge, //clipBehavior,
              child: Stack(children: [
                OverflowBox(
                    alignment: Alignment.topLeft,
                    minWidth: 0.0,
                    minHeight: 0.0,
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: ValueListenableBuilder(
                        valueListenable: _transformationController,
                        builder: (context, value, child) => Transform(
                              transform: value,
                              child: manvMap,
                            ))),
                Align(
                    alignment: widget.positionType.alignment * 1.05,
                    child: const Icon(Icons.location_on, color: Colors.blue)),
              ]))),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendEntry(
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      AppLocalizations.of(context)!.mapLegendPosition),
                  _buildLegendEntry(const Icon(ManvIcons.patientOnMap),
                      AppLocalizations.of(context)!.mapLegendPatient),
                  _buildLegendEntry(const Icon(ManvIcons.location),
                      AppLocalizations.of(context)!.mapLegendLocation),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendEntry(
                        _buildColorLegendSymbol(MANVMap.buildingColor),
                        AppLocalizations.of(context)!.mapLegendBuilding),
                    _buildLegendEntry(_buildColorLegendSymbol(backgroundColor),
                        AppLocalizations.of(context)!.mapLegendEdge),
                    _buildLegendEntry(_buildColorLegendSymbol(Colors.black),
                        AppLocalizations.of(context)!.mapLegendShadow)
                  ])
            ])));
  }

  Widget _buildLegendEntry(Widget icon, String text) =>
      Row(children: [icon, Text(text)]);

  Widget _buildColorLegendSymbol(Color color) =>
      Container(height: 24, width: 24, color: color);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: viewportSize.width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildLegend(context),
          _buildMapViewport(),
          _buildControls()
        ]));
  }
}
