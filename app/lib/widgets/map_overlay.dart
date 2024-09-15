import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/models/offset_ray.dart';
import 'package:manvsim/widgets/patient_map.dart';

class PatientMapOverlay extends StatefulWidget {
  const PatientMapOverlay(this.mapData, {super.key});

  final MapData mapData;

  @override
  State<StatefulWidget> createState() => _PatientMapOverlayState();
}

enum MapOverlayPositions { center, bottomCenter }

class _PatientMapOverlayState extends State<PatientMapOverlay>
    with TickerProviderStateMixin {
  /// Size of the viewport.
  static const Size viewportSize = Size(300, 400);

  /// Player position on the viewport.
  Offset get positionViewport {
    return switch (positionType) {
      MapOverlayPositions.bottomCenter =>
        boundingBox.bottomCenter.translate(0, -10),
      MapOverlayPositions.center => boundingBox.center
    };
  }

  Rect get boundingBox => Offset.zero & viewportSize;

  final positionType = MapOverlayPositions.bottomCenter;

  /// Controller for the Matrix4 transformations.
  late final TransformationController _translationController;
  late final TransformationController _rotationScaleController;
  late final TransformationController _tiltController;

  /// Animation "moving the center".
  Animation<Matrix4> _matrixAnimation =
      AlwaysStoppedAnimation(Matrix4.identity());
  late final AnimationController _animationController;

  late PatientMap child;
  late ValueNotifier<Offset> positionNotifier;

  /// Last tapped position on overlay. Used to ignore small changes.
  Offset lastTapped = const Offset(0, 0);

  List<Rect> get buildings => widget.mapData.buildings;

  Rect get mapRect => Offset.zero & widget.mapData.size;

  Offset targetCenterToTranslation(Offset center) =>
      -(center - positionViewport);

  @override
  void initState() {
    super.initState();
    positionNotifier = ValueNotifier(widget.mapData.startingPoint);
    child = PatientMap(widget.mapData, positionNotifier);
    _translationController = TransformationController(Matrix4.identity()
      ..setTranslation(
          targetCenterToTranslation(positionNotifier.value).toVector3()))
      ..addListener(_onTransformationControllerChange);
    _rotationScaleController = TransformationController()
      ..addListener(_onTransformationControllerChange);
    _tiltController = TransformationController()
      ..addListener(_onTransformationControllerChange);
    _animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _translationController.dispose();
    _rotationScaleController.dispose();
    _tiltController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _buildMapViewPort(),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Column(children: [
          IconButton(
              onPressed: () => _tilt(-pi / 12),
              icon: const Icon(Icons.arrow_drop_down)),
          IconButton(
              onPressed: () => _tilt(pi / 12),
              icon: const Icon(Icons.arrow_drop_up)),
        ]),
        Column(children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                onPressed: () => _rotate(-pi / 12),
                icon: const Icon(Icons.rotate_left)),
            IconButton(
                onPressed: () => _onNewDirection(
                    toScene(positionViewport.translate(0, -10))),
                icon: const Icon(Icons.arrow_circle_up)),
            IconButton(
                onPressed: () => _rotate(pi / 12),
                icon: const Icon(Icons.rotate_right)),
          ]),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => _onNewDirection(
                      toScene(positionViewport.translate(-10, 0))),
                  icon: const Icon(Icons.arrow_circle_left)),
              IconButton(
                  onPressed: _onMoveEnd, icon: const Icon(Icons.stop_circle)),
              IconButton(
                  onPressed: () => _onNewDirection(
                      toScene(positionViewport.translate(10, 0))),
                  icon: const Icon(Icons.arrow_circle_right)),
            ],
          )
        ]),
        Column(children: [
          IconButton(
              onPressed: () => _scale(2), icon: const Icon(Icons.zoom_in)),
          IconButton(
              onPressed: () => _scale(0.5), icon: const Icon(Icons.zoom_out)),
        ])
      ])
    ]);
  }

  Widget _buildMapViewPort() {
    var locationIcon = const Icon(Icons.location_on, color: Colors.blue);
    return Container(
        width: viewportSize.width,
        height: viewportSize.height,
        decoration: BoxDecoration(
          border: Border.all(width: 3),
        ),
        child: Stack(children: [
          Listener(
              child: GestureDetector(
                  onLongPressStart: (details) =>
                      _onNewTargetOffset(details.localPosition),
                  onLongPressUp: _onMoveEnd,
                  onLongPressMoveUpdate: (details) =>
                      _onNewTargetOffset(details.localPosition),
                  child: ClipRect(
                      clipBehavior: Clip.hardEdge, //clipBehavior,
                      child: OverflowBox(
                          alignment: Alignment.topLeft,
                          minWidth: 0.0,
                          minHeight: 0.0,
                          maxWidth: double.infinity,
                          maxHeight: double.infinity,
                          child: Transform(
                            transform: _tiltController.value *
                                (_rotationScaleController.value *
                                    _translationController.value),
                            child: child,
                          ))))),
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: positionType == MapOverlayPositions.center
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                locationIcon,
                Visibility(visible: false, child: locationIcon)
              ])
            ],
          ))
        ]));
  }

  /// Start animation moving the middle to the edge.
  void _onNewTargetOffset(Offset tappedPosition) {
    if ((lastTapped - tappedPosition).distance < 10) {
      return;
    }
    lastTapped = tappedPosition;
    _onNewDirection(toScene(tappedPosition));
  }

  void _onNewDirection(Offset targetPoint) {
    Offset self = toScene(positionViewport);
    Offset target = getTarget(self, self - targetPoint);
    _onMoveEnd();
    _matrixAnimation = Matrix4Tween(
            begin: _translationController.value,
            end: _translationController.value.clone()
              ..setTranslation(targetCenterToTranslation(target).toVector3()))
        .animate(_animationController)
      ..addListener(_onAnimate);
    double distance = (target - self).distance;
    _animationController.duration = Duration(seconds: max(distance ~/ 100, 1));
    _animationController.forward();
  }

  void _onMoveEnd() {
    _matrixAnimation.removeListener(_onAnimate);
    _animationController.reset();
  }

  void _onTransformationControllerChange() {
    // A change to the TransformationController's value is a change to the
    // state.
    setState(() {});
  }

  /// Translates the Transform Matrix4 during the animation.
  void _onAnimate() {
    _translationController.value = _matrixAnimation.value;
    positionNotifier.value = toScene(positionViewport);
  }

  /// Uses vector_math to determine where the path hits the edge.
  Offset getTarget(Offset origin, Offset direction) {
    OffsetRay dirRay = OffsetRay(origin, direction);
    double distance = [mapRect, ...buildings]
        .map(dirRay.intersectsWithRect)
        .whereType<double>()
        .where((element) => element < 0)
        .map((distance) => distance * 0.95)
        .reduce(max);
    return dirRay.at(distance);
  }

  void _rotate(double rotation) {
    final Offset focalPointScene = _rotationScaleController.toScene(
      positionViewport,
    );
    _rotationScaleController.value = _rotationScaleController.value.clone()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateZ(-rotation)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
  }

  void _tilt(double rotation) {
    final Offset focalPointScene = _rotationScaleController.toScene(
      positionViewport,
    );
    _tiltController.value = _tiltController.value.clone()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateX(-rotation)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
  }

  void _scale(double scale) {
    final Offset focalPointScene =
        _rotationScaleController.toScene(positionViewport);
    _rotationScaleController.value = _rotationScaleController.value.clone()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..scale(scale)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
  }

  Offset toScene(Offset viewportOffset) => _translationController
      .toScene(_rotationScaleController.toScene(viewportOffset));
}
