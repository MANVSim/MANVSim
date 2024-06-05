import 'package:flutter/material.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/patient_overview.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;
  final Patient? patient;

  const PatientScreen({super.key, required this.patientId, this.patient});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late Future<Patient> futurePatient;

  @override
  void initState() {
    futurePatient = widget.patient != null
        ? Future(() => widget.patient!)
        : fetchPatient(widget.patientId);
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
            onRefresh: () {
              // TODO: are child widgets reloaded?
              setState(() {
                futurePatient = fetchPatient(widget.patientId);
              });
              return futurePatient;
            },
            child: FutureBuilder(
                future: futurePatient,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          Card(child: PatientOverview(patient: snapshot.data!)),
                          ActionSelection(patient: snapshot.data!)
                        ]));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                })));
  }
}
