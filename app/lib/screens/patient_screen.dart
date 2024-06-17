import 'package:flutter/material.dart';

import 'package:manvsim/models/patient_location.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
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
    futurePatientLocation = arriveAtPatient(widget.patientId);
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
            child: FutureBuilder(
                future: futurePatientLocation,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (!snapshot.hasData ||
                      snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var (patient, location) = snapshot.data!;
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
      futurePatientLocation = arriveAtPatient(widget.patientId);
    });
    return futurePatientLocation;
  }
}
