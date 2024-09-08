import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/models/offset_ray.dart';
import 'package:manvsim/models/types.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:manvsim/widgets/patient_map.dart';

class PatientMapOverlay extends StatefulWidget {
  const PatientMapOverlay(this.patientLocations, this.buildings, {super.key});

  final List<PatientPosition> patientLocations;
  final List<Rect> buildings;

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

  @override
  void initState() {
    super.initState();
    positionNotifier = ValueNotifier(const Offset(400, 400));
    child = PatientMap(widget.patientLocations, buildings, positionNotifier);
    _transformationController = TransformationController(
        Matrix4.identity()
          ..setTranslation(-Vector3(mapSize.width, mapSize.height, 0) / 2))
      ..addListener(_onTransformationControllerChange);
    _animationController = AnimationController(
      vsync: this,
    );
    positionNotifier.value = _transformationController.toScene(middle);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onLongPressMoveUpdate: (details) {
                    _onMoveEnd();
                    _onNewTargetOffset(details.localPosition);
                  },
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
    Offset self = _transformationController.toScene(middle);
    Offset target = getTarget(tappedPosition, self);
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
      ..setTranslation(vector3FromOffset(_offsetAnimation.value));
    positionNotifier.value = _transformationController.toScene(middle);
  }

  /// Uses vector_math to determine where the path hits the edge.
  Offset getTarget(Offset originalTarget, Offset origin) {
    Offset direction = middle - originalTarget;
    OffsetRay dirRay = OffsetRay(origin, direction);
    Offset intersectionPoint = dirRay.at([mapRect, ...buildings]
        .map(dirRay.intersectsWithRect)
        .whereType<double>()
        .where((element) => element < 0)
        .map((distance) => distance * 0.99)
        .reduce(max));
    return intersectionPoint;
  }

  List<Rect> get buildings => widget.buildings;

  Size get mapSize => child.size;

  Rect get mapRect => Offset.zero & mapSize;

  Vector3 vector3FromOffset(Offset offset) => Vector3(offset.dx, offset.dy, 0);

  Offset targetCenterToTranslation(Offset center) => -(center - middle);
}
