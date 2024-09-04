import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/map_service.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/widgets/patient_map.dart';

class PatientMapScreen extends StatefulWidget {
  const PatientMapScreen({super.key});

  @override
  State<PatientMapScreen> createState() => _PatientMapScreenState();
}

class _PatientMapScreenState extends State<PatientMapScreen> {
  late Future<List<PatientPosition>?> futurePatientPositions;
  late Future<List<Rect>> futureBuildings;

  @override
  void initState() {
    futureBuildings = MapService.fetchBuildings();
    futurePatientPositions = MapService.fetchPatientPositions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.mapScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              futurePatientPositions = MapService.fetchPatientPositions();
            });
            return futurePatientPositions;
          },
          child: ApiFutureBuilder<List<List<dynamic>?>>(
              future: Future.wait([futurePatientPositions, futureBuildings]),
              builder: (context, list) {
                var patientPositions = list[0] as List<PatientPosition>;
                var buildings = list[1] as List<Rect>;
                return Center(
                    child: PatientMapOverlay(
                        child: PatientMap(patientPositions, buildings)));
              })),
    );
  }
}

class PatientMapOverlay extends StatefulWidget {
  const PatientMapOverlay({super.key, required this.child});

  final PatientMap child;

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

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController(Matrix4.identity()
      ..setTranslation(Vector3(
          -widget.child.size.width / 2, -widget.child.size.height / 2, 0)))
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
                            child: widget.child,
                          ))))),
          const Center(child: Icon(Icons.location_on, color: Colors.blue)),
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
  }

  /// Uses vector_math to determine where the path hits the edge.
  Offset getTarget(Offset originalTarget, Offset origin) {
    Offset direction = middle - originalTarget;
    var renderBox = Aabb3.minMax(Vector3.zero(),
        Vector3(widget.child.size.width, widget.child.size.height, 0));
    Ray dirRay = Ray.originDirection(
        vector3FromOffset(origin), vector3FromOffset(direction));
    double distance = dirRay.intersectsWithAabb3(renderBox) ?? 0; // TODO
    Vector3 intersectionPoint = dirRay.at(distance);
    return offsetFromVector3(intersectionPoint);
  }

  Vector3 vector3FromOffset(Offset offset) => Vector3(offset.dx, offset.dy, 0);

  Offset offsetFromVector3(Vector3 vector3) => Offset(vector3.x, vector3.y);

  Offset targetCenterToTranslation(Offset center) => -(center - middle);
}
