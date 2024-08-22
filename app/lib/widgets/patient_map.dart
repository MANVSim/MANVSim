import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/patient_service.dart';

class PatientMap extends StatelessWidget {
  static const double width = 1000;
  static const double height = 1000;

  static const double padding = 50;

  PatientMap(this.patientLocations) : size = Size(width, height);

  final List<PatientPosition> patientLocations;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height + padding,
        width: size.width + padding,
        decoration: BoxDecoration(
            border: Border.all(width: 5, color: Colors.black26),
            gradient: LinearGradient(
                colors: [Colors.white, Colors.amberAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Stack(
          children: getPatients(context),
        ));
  }

  List<Positioned> getPatients(BuildContext context) {
    return patientLocations
        .map((patientPosition) => Positioned(
              child: IconButton(
                  onPressed: () => PatientService.goToPatientScreen(
                      patientPosition.id, context),
                  icon: Icon(Icons.person)),
              top: patientPosition.position.y,
              left: patientPosition.position.x,
            ))
        .toList();
  }
}

/////////////////////////////////////////////////////////////////////////

class PatientMap1 extends CustomPainter {
  PatientMap1(this.patientLocations);

  final List<PatientPosition> patientLocations;

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.dra
  }

  @override
  bool shouldRepaint(PatientMap1 oldDelegate) {
    return oldDelegate.patientLocations != patientLocations;
  }
}

/*class PatientMapOverlay extends StatelessWidget {

  PatientMapOverlay(this.child);

  final PatientMap child;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return TwoDimensionalScrollable(
        horizontalDetails: ScrollableDetails.horizontal(
            controller: _horizontalScrollController),
        verticalDetails: ScrollableDetails.vertical(
            controller: _verticalScrollController),
        viewportBuilder: (context, verticalPosition, horizontalPosition) => );
  }

}*/

/*class PatientMapOverlayState extends TwoDimensionalScrollView {

  PatientMapOverlayState({required super.delegate});

  @override
  Widget buildViewport(BuildContext context, ViewportOffset verticalOffset,
      ViewportOffset horizontalOffset) {
    // TODO: implement buildViewport
    TwoDimensionalChildBuilderDelegate(builder: (context, vicinity) => PatientMap());
    TwoDimensionalViewport(
        verticalOffset: null,
        verticalAxisDirection: null,
        horizontalOffset: null,
        horizontalAxisDirection: null,
        delegate: null,
        mainAxis: null);
    throw UnimplementedError();
  }
}*/
