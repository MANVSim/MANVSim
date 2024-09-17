import 'dart:math';

import 'package:flutter/foundation.dart';
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

  /// Where the viewer is positioned on the Viewport.
  final positionType = MapOverlayPositions.bottomCenter;

  /// Controller for view transformations (using [Matrix4]).
  late final CustomTransformationController _transformationController;

  /// Animation "moving the center".
  Animation<Offset> _translationAnimation =
      const AlwaysStoppedAnimation(Offset.zero);
  late final AnimationController _animationController;

  late PatientMap patientMap;
  late ValueNotifier<Offset> positionNotifier;

  /// Last tapped position on overlay. Used to ignore small changes.
  Offset lastTapped = Offset.zero;

  /// Player position on the viewport.
  Offset get positionOnViewport {
    return switch (positionType) {
      MapOverlayPositions.bottomCenter =>
        boundingBox.bottomCenter.translate(0, -20),
      MapOverlayPositions.center => boundingBox.center
    };
  }

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
    positionNotifier = ValueNotifier(widget.mapData.startingPoint);
    patientMap = PatientMap(widget.mapData, positionNotifier);
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

  /// Start animation moving the middle to the edge.
  void _onNewTargetOffset(Offset tappedPosition) {
    if ((lastTapped - tappedPosition).distance < 10) {
      return;
    }
    lastTapped = tappedPosition;
    _onNewDirection(toScene(tappedPosition));
  }

  void _onNewDirection(Offset targetPoint) {
    Offset self = toScene(positionOnViewport);
    Offset target = getTarget(self, self - targetPoint);
    _onMoveEnd();
    _translationAnimation = Tween<Offset>(
            begin: _transformationController.currentTranslation,
            end: targetPositionToTranslation(target))
        .animate(_animationController)
      ..addListener(_onAnimate);
    double distance = (target - self).distance;
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
                icon: const Icon(Icons.arrow_circle_left)),
            IconButton(
                onPressed: _onMoveEnd, icon: const Icon(Icons.stop_circle)),
            IconButton(
                onPressed: () => _onNewDirection(
                    toScene(positionOnViewport.translate(10, 0))),
                icon: const Icon(Icons.arrow_circle_right)),
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
          decoration:
              BoxDecoration(border: Border.all(width: 3), color: Colors.grey),
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
                              child: patientMap,
                            ))),
                Align(
                    alignment: positionType == MapOverlayPositions.center
                        ? Alignment.center
                        : Alignment.bottomCenter,
                    child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(height: 10)
                        ])),
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

class CustomTransformationController extends ChangeNotifier
    implements ValueListenable<Matrix4> {
  CustomTransformationController(this.focalPoint);

  double currentTilt = 0;
  double currentRotation = 0;
  double currentScale = 1;
  Offset currentTranslation = Offset.zero;

  Matrix4 tiltMatrix = Matrix4.identity();
  Matrix4 rotationScaleMatrix = Matrix4.identity();
  Matrix4 translationMatrix = Matrix4.identity();

  Offset focalPoint;

  @override
  Matrix4 get value => tiltMatrix * (rotationScaleMatrix * translationMatrix);

  void rotate(double rotation) {
    currentRotation += rotation;
    final Offset focalPointScene = rotated(focalPoint);
    rotationScaleMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateZ(-rotation)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void tilt(double tilt) {
    double newTilt = currentTilt + tilt;
    if (newTilt.abs() > 1.5) return;
    final Offset focalPointScene = rotated(focalPoint);
    currentTilt = newTilt;
    tiltMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateX(-tilt)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void scale(double scale) {
    double newScale = currentScale * scale;
    if (newScale < 0.25 || newScale > 2) return;
    final Offset focalPointScene = rotated(focalPoint);
    currentScale = newScale;
    rotationScaleMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..scale(scale)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void setTranslation(Offset translation) {
    currentTranslation = translation;
    translationMatrix = translationMatrix
      ..setTranslation(translation.toVector3());
    notifyListeners();
  }

  Offset toScene(Offset viewportPoint) {
    // On viewportPoint, perform the inverse transformation of the scene to get
    // where the point would be in the scene before the transformation.
    final Matrix4 inverseMatrix = Matrix4.inverted(value);
    return inverseMatrix.transform3(viewportPoint.toVector3()).toOffset();
  }

  Offset rotated(Offset viewportPoint) {
    Matrix4 inverseMatrix = Matrix4.inverted(tiltMatrix * rotationScaleMatrix);
    return inverseMatrix.transform3(viewportPoint.toVector3()).toOffset();
  }
}
