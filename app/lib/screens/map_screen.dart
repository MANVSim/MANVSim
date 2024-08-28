import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:manvsim/services/patient_service.dart';
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

  @override
  void initState() {
    futurePatientPositions = PatientService.fetchPatientPositions();
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
              futurePatientPositions = PatientService.fetchPatientPositions();
            });
            return futurePatientPositions;
          },
          child: ApiFutureBuilder<List<PatientPosition>>(
              future: futurePatientPositions,
              builder: (context, patientPositions) => Center(
                  child:
                      PatientMapOverlay(child: PatientMap(patientPositions))))),
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
  static const height = 300.0;
  /// middle of the viewport
  final Offset middle = const Offset(width / 2, height / 2);

  /// Controller for the Matrix4 transformations.
  late final TransformationController _transformationController;

  /// Animation "moving the center".
  Animation<Offset>? _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController()
      ..addListener(_onTransformationControllerChange);
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _controller.dispose();
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
    _animation = Tween<Offset>(begin: self - middle, end: target - middle)
        .animate(_controller)
      ..addListener(_onAnimate);
    double distance = (target - self).distance;
    _controller.duration = Duration(seconds: distance.floor() ~/ 100);
    _controller.forward();
  }

  void _onMoveEnd() {
    _animation?.removeListener(_onAnimate);
    _controller.stop();
    _controller.reset();
  }

  void _onTransformationControllerChange() {
    // A change to the TransformationController's value is a change to the
    // state.
    setState(() {});
  }

  /// Translates the Transform Matrix4 during the animation.
  void _onAnimate() {
    _transformationController.value = _transformationController.value.clone()
      ..setTranslation(
          Vector3(-_animation!.value.dx, -_animation!.value.dy, 0));
  }

  /// Uses vector_math to determine where the path hits the edge.
  Offset getTarget(Offset originalTarget, Offset origin) {
    var renderBox = Aabb3.fromQuad(Quad.points(
        Vector3.zero(),
        Vector3(widget.child.size.width, 0, 0),
        Vector3(0, widget.child.size.height, 0),
        Vector3(widget.child.size.width, widget.child.size.height, 0)));
    Offset direction =
        middle - _transformationController.toScene(originalTarget);
    Ray dirRay = Ray.originDirection(Vector3(middle.dx, middle.dy, 0),
        Vector3(direction.dx, direction.dy, 0));
    double distance = dirRay.intersectsWithAabb3(renderBox) ?? 0; // TODO
    Vector3 intersectionPoint = dirRay.at(distance);
    return Offset(intersectionPoint.x, intersectionPoint.y);
  }
}
