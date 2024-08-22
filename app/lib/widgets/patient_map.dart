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
