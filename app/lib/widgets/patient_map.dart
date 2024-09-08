import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/screens/map_screen.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class PatientMap extends StatelessWidget {
  static const double width = 1000;
  static const double height = 1000;

  static const double padding = 50;

  const PatientMap(this.patientLocations, this.buildings, this.positionNotifier,
      {super.key})
      : size = const Size(width, height);

  final List<PatientPosition> patientLocations;
  final List<Rect> buildings;
  final Size size;

  final ValueNotifier<Offset> positionNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.05,
                repeat: ImageRepeat.repeat,
                image: AssetImage("assets/map_background.jpg")),
            gradient: LinearGradient(
                colors: [Colors.white, Colors.amberAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Stack(
          children: [
            CustomPaint(painter: _MapRaw(buildings, positionNotifier)),
            ...getPatients(context)
          ],
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

class _MapRaw extends CustomPainter {
  final List<Rect> buildings;

  final ValueNotifier<Offset> viewerPositionNotifier;

  Offset get viewerPosition => viewerPositionNotifier.value;

  _MapRaw(this.buildings, this.viewerPositionNotifier)
      : super(repaint: viewerPositionNotifier);

  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    Paint buildingPaint = Paint()..color = Colors.grey;
    for (Rect building in buildings) {
      for (Path shadow in _getShadow(building, size)) {
        canvas.drawPath(shadow, shadowPaint);
      }

      canvas.drawRect(building, buildingPaint);
    }
  }

  @override
  bool shouldRepaint(_MapRaw oldDelegate) => true;

  List<Path> _getShadow(Rect building, Size size) {
    return [
      shadowEdge(building.bottomRight, building.bottomLeft),
      shadowEdge(building.bottomLeft, building.topLeft),
      shadowEdge(building.topLeft, building.topRight),
      shadowEdge(building.topRight, building.bottomRight)
    ];
  }

  Path shadowEdge(Offset lineStart, Offset lineEnd) {
    Rect boundingRect = Offset.zero & const Size(1000, 1000);

    Ray ray = rayFromOffsets(viewerPosition, viewerPosition - lineStart);
    Offset end =
        offsetFromVector3(ray.at(ray.intersectsWithRect(boundingRect)!));

    Ray ray2 = rayFromOffsets(viewerPosition, viewerPosition - lineEnd);
    Offset end2 =
        offsetFromVector3(ray2.at(ray2.intersectsWithRect(boundingRect)!));

    return Path()..addPolygon([end, lineStart, lineEnd, end2], true);
  }
}
