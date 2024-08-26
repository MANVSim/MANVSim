import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

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

  final Widget child;

  @override
  State<StatefulWidget> createState() => _PatientMapOverlayState();
}

class _PatientMapOverlayState extends State<PatientMapOverlay>
    with TickerProviderStateMixin {
  static const width = 300.0;
  static const height = 300.0;

  late final TransformationController _transformationController;
  Animation<Offset>? _animation;
  late AnimationController _controller;

  Offset direction = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController()
      ..addListener(_onTransformationControllerChange);
    _controller = AnimationController(
      vsync: this,
    )..addListener(_onAnimate);
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
                  onLongPressStart: _onLongPressDown,
                  onLongPressEnd: (details) {
                    _controller.stop();
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

  void _onLongPressDown(LongPressStartDetails details) {
    _controller.reset();
    Offset self = const Offset(width / 2, height / 2);
    final vector_math.Vector3 translationVector =
        _transformationController.value.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    print(translation);
    direction = details.localPosition - self;
    _animation =
        Tween<Offset>(begin: translation, end: details.localPosition - self)
            .animate(_controller);
    _controller.duration = Duration(seconds: 10);
    _controller.forward();
    print(details.localPosition);
  }

  void _onTransformationControllerChange() {
    // A change to the TransformationController's value is a change to the
    // state.
    setState(() {});
  }

  void _onAnimate() {
    _transformationController.value = _transformationController.value.clone()
      ..translate(
        -direction.dx.sign,
        -direction.dy.sign,
      );
    print(_transformationController.value);
  }

  void _onAnimate2() {
    // Translate such that the resulting translation is _animation.value.
    final vector_math.Vector3 translationVector =
        _transformationController.value.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    final Offset translationScene = _transformationController.toScene(
      translation,
    );
    final Offset animationScene = _transformationController.toScene(
      _animation!.value,
    );
    final Offset translationChangeScene = animationScene - translationScene;
    _transformationController.value = _transformationController.value.clone()
      ..translate(-translationChangeScene.dx, -translationChangeScene.dy);
  }
}
