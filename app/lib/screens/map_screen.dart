import 'package:flutter/material.dart';
import 'package:manvsim/models/types.dart';

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
  TransformationController _transformationController =
      TransformationController();

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
                  child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3),
                      ),
                      child: InteractiveViewer(
                          constrained: false,
                          transformationController: _transformationController,
                          child: PatientMap(patientPositions))))),
        ));
  }
}
