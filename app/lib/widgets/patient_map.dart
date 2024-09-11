import 'package:flutter/material.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/models/offset_ray.dart';
import 'package:manvsim/services/patient_service.dart';

class PatientMap extends StatelessWidget {

  const PatientMap(this.mapData, this.positionNotifier, {super.key});

  final MapData mapData;

  final ValueNotifier<Offset> positionNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: mapData.size.height,
        width: mapData.size.width,
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
            ...getPatients(context),
            CustomPaint(painter: _MapRaw(mapData.buildings, positionNotifier))
          ],
        ));
  }

  List<Positioned> getPatients(BuildContext context) {
    return mapData.patientsPositions
        .map((patientPosition) => Positioned(
              top: patientPosition.position.dy,
              left: patientPosition.position.dx,
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
    Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;
    for (Rect building in buildings) {
      for (Path shadow in _getShadow(building, size)) {
        canvas.drawPath(shadow, shadowPaint);
      }

      canvas.drawRect(building, buildingPaint);
      //canvas.drawRect(building, borderPaint);
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

    OffsetRay ray = OffsetRay(viewerPosition, viewerPosition - lineStart);
    Offset end = ray.intersectionWithRect(boundingRect)!;

    OffsetRay ray2 = OffsetRay(viewerPosition, viewerPosition - lineEnd);
    Offset end2 = ray2.intersectionWithRect(boundingRect)!;

    return Path()..addPolygon([end, lineStart, lineEnd, end2], true);
  }
}
