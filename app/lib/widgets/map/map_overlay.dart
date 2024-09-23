import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/utils/custom_transformation_controller.dart';
import 'package:manvsim/utils/offset_ray.dart';
import 'package:manvsim/widgets/map/manv_map.dart';

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
      super.key});

  final MapData mapData;

  /// Where the viewer is positioned on the Viewport.
  final MapOverlayViewerPositions positionType;

  @override
  State<StatefulWidget> createState() => _PatientMapOverlayState();
}

class _PatientMapOverlayState extends State<PatientMapOverlay>
    with SingleTickerProviderStateMixin {
  /// Size of the viewport.
  final Size viewportSize = const Size(300, 400);

  late MANVMap manvMap;
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
    manvMap = MANVMap(
        mapData: widget.mapData,
        positionNotifier: positionNotifier,
        transformationController: _transformationController);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onNewTargetOffset(Offset tappedOnViewport) {
    if ((lastTapped - tappedOnViewport).distance < 10) {
      return;
    }
    lastTapped = tappedOnViewport;
    _onNewDirection(toScene(tappedOnViewport));
  }

  /// Start animation moving the middle to the edge.
  void _onNewDirection(Offset tappedOnScene) {
    Offset viewerOnScene = positionNotifier.value;
    Offset targetOnScene =
        _getMovementTarget(viewerOnScene, viewerOnScene - tappedOnScene);
    _onMoveEnd();
    _translationAnimation = Tween<Offset>(
            begin: _transformationController.currentTranslation,
            end: targetPositionToTranslation(targetOnScene))
        .animate(_animationController)
      ..addListener(_onAnimate);
    double distance = (targetOnScene - viewerOnScene).distance;
    _animationController.duration = Duration(seconds: max(distance ~/ 100, 1));
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
  Offset _getMovementTarget(Offset origin, Offset direction) {
    OffsetRay dirRay = OffsetRay(origin, direction);
    double distance = [mapRect, ...buildings]
        .map(dirRay.intersectsWithRect)
        .whereType<double>()
        .where((element) => element < 0)
        .map((distance) => distance * 0.95)
        .reduce(max);
    return dirRay.at(distance);
  }

  Widget _buildControls() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
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
              onPressed: () => _onNewDirection(
                  toScene(positionOnViewport.translate(0, -10))),
              icon: const Icon(Icons.arrow_circle_up)),
          IconButton(
              onPressed: () => _transformationController.rotate(pi / 12),
              icon: const Icon(Icons.rotate_right)),
        ]),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => _onNewDirection(
                    toScene(positionOnViewport.translate(-10, 0))),
                icon: const Icon(Icons.arrow_circle_left_outlined)),
            IconButton(
                onPressed: _onMoveEnd, icon: const Icon(Icons.stop_circle)),
            IconButton(
                onPressed: () => _onNewDirection(
                    toScene(positionOnViewport.translate(10, 0))),
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
    ]);
  }

  Widget _buildMapViewport() {
    return GestureDetector(
      onLongPressStart: (details) => _onNewTargetOffset(details.localPosition),
      onLongPressUp: _onMoveEnd,
      onLongPressMoveUpdate: (details) =>
          _onNewTargetOffset(details.localPosition),
      child: Container(
          width: viewportSize.width,
          height: viewportSize.height,
          decoration: BoxDecoration(
              border: Border.all(width: 3),
              // Background for empty space:
              color: Colors.grey.shade700),
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

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildMapViewport(), _buildControls()]);
  }
}
