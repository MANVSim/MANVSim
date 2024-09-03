import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/patient_service.dart';

class PatientMap extends StatelessWidget {
  static const double width = 1000;
  static const double height = 1000;

  static const double padding = 50;

  const PatientMap(this.patientLocations, {super.key})
      : size = const Size(width, height);

  final List<PatientPosition> patientLocations;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            border: Border.all(width: 8, color: Colors.black26),
            image: const DecorationImage(
                opacity: 0.05,
                repeat: ImageRepeat.repeat,
                image: AssetImage("assets/map_background.jpg")),
            gradient: const LinearGradient(
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
              top: patientPosition.position.y,
              left: patientPosition.position.x,
              child: IconButton(
                  onPressed: () => PatientService.goToPatientScreen(
                      patientPosition.id, context),
                  icon: const Icon(Icons.person)),
            ))
        .toList();
  }
}
