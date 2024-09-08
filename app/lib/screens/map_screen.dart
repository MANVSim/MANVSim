import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/services/map_service.dart';
import 'package:manvsim/widgets/map_overlay.dart';

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
                    child: PatientMapOverlay(patientPositions, buildings));
              })),
    );
  }
}
