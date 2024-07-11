import 'package:flutter/material.dart';

import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/patient_overview.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;

  const PatientScreen({super.key, required this.patientId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late Future<PatientLocation> futurePatientLocation;

  @override
  void initState() {
    futurePatientLocation = PatientService.arriveAtPatient(widget.patientId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!
              .patientScreenName(widget.patientId)),
          actions: const <Widget>[LogoutButton()],
        ),
        body: RefreshIndicator(
            onRefresh: refresh,
            child: ApiFutureBuilder(
                future: futurePatientLocation,
                builder: (context, data) {
                  var (patient, location) = data;
                  return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        Card(child: PatientOverview(patient: patient)),
                        ActionSelection(
                            patient: patient,
                            locations: [location],
                            refreshPatient: refresh)
                      ]));
                })));
  }

  Future refresh() {
    setState(() {
      // TODO necessary to leave before?
      futurePatientLocation = LocationService.leaveLocation()
          .then((v) => PatientService.arriveAtPatient(widget.patientId));
    });
    return futurePatientLocation;
  }
}
