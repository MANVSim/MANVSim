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

class _PatientMapOverlayState extends State<PatientMapOverlay>
    with TickerProviderStateMixin {
  /// width of the viewport
  static const width = 300.0;

  /// height of the viewport
  static const height = 400.0;

  /// middle of the viewport
  final Offset middle = const Offset(width / 2, height / 2);

  /// Controller for the Matrix4 transformations.
  late final TransformationController _transformationController;

  /// Animation "moving the center".
  Animation<Offset> _offsetAnimation =
      const AlwaysStoppedAnimation(Offset.zero);
  late final AnimationController _animationController;

  late PatientMap child;
  late ValueNotifier<Offset> positionNotifier;

  /// Last tapped position on overlay. Used to ignore small changes.
  Offset lastTapped = const Offset(0, 0);

  List<Rect> get buildings => widget.mapData.buildings;

  Rect get mapRect => Offset.zero & widget.mapData.size;

  Offset targetCenterToTranslation(Offset center) => -(center - middle);

  @override
  void initState() {
    super.initState();
    positionNotifier = ValueNotifier(widget.mapData.startingPoint);
    child = PatientMap(widget.mapData, positionNotifier);
    _transformationController = TransformationController(Matrix4.identity()
      ..setTranslation(
          targetCenterToTranslation(positionNotifier.value).toVector3()))
      ..addListener(_onTransformationControllerChange);
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

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _buildMapViewPort(),
      Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: () {
              _transformationController.value.rotateX(-pi / 10);
            },
            icon: const Icon(Icons.turn_slight_left)),
        IconButton(
            onPressed: () {
              _transformationController.value.rotateX(pi / 10);
            },
            icon: const Icon(Icons.turn_slight_right)),
      ]),
      IconButton(
          onPressed: () {
            _transformationController.value.scale(1.2);
          },
          icon: const Icon(Icons.add)),
      IconButton(
          onPressed: () {
            _transformationController.value.scale(0.8);
          },
          icon: const Icon(Icons.minimize)),
    ]);
  }

  Widget _buildMapViewPort() {
    var locationIcon = const Icon(Icons.location_on, color: Colors.blue);
    return Container(
        width: width,
        height: height,
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
                            transform: _transformationController.value,
                            //alignment: alignment,
                            child: child,
                          ))))),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              locationIcon,
              Visibility(visible: false, child: locationIcon)
            ]),
          )
        ]));
  }

  /// Start animation moving the middle to the edge.
  void _onNewTargetOffset(Offset tappedPosition) {
    if ((lastTapped - tappedPosition).distance < 5) {
      return;
    }
    lastTapped = tappedPosition;
    _onNewDirection(middle - tappedPosition);
  }

  void _onNewDirection(Offset direction) {
    Offset self = _transformationController.toScene(middle);
    Offset target = getTarget(self, direction);
    _onMoveEnd();
    _offsetAnimation = Tween<Offset>(
            begin: targetCenterToTranslation(self),
            end: targetCenterToTranslation(target))
        .animate(_animationController)
      ..addListener(_onAnimate);
    double distance = (target - self).distance;
    _animationController.duration = Duration(seconds: max(distance ~/ 100, 1));
    _animationController.forward();
  }

  void _onMoveEnd() {
    _offsetAnimation.removeListener(_onAnimate);
    _animationController.reset();
  }

  void _onTransformationControllerChange() {
    // A change to the TransformationController's value is a change to the
    // state.
    setState(() {});
  }

  /// Translates the Transform Matrix4 during the animation.
  void _onAnimate() {
    _transformationController.value = _transformationController.value.clone()
      ..setTranslation(_offsetAnimation.value.toVector3());
    positionNotifier.value = _transformationController.toScene(middle);
  }

  /// Uses vector_math to determine where the path hits the edge.
  Offset getTarget(Offset origin, Offset direction) {
    OffsetRay dirRay = OffsetRay(origin, direction);
    double distance = [mapRect, ...buildings]
        .map(dirRay.intersectsWithRect)
        .whereType<double>()
        .where((element) => element < 0)
        .map((distance) => distance * 0.99)
        .reduce(max);
    return dirRay.at(distance);
  }
}
