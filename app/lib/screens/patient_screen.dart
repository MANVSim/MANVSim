import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/patient_overview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/manv_icons.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;

  const PatientScreen({super.key, required this.patientId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late Future<Patient?> futurePatient;

  @override
  void initState() {
    futurePatient = PatientService.arriveAtPatient(widget.patientId);

    super.initState();
  }

  Tab _buildTab(String title, IconData icon) {
    return Tab(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon),
        const SizedBox(
          width: 8,
        ),
        Text(title),
      ]),
    );
  }

  Widget _buildTabView(Patient patient, List<Widget> children, bool expanded) {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          Card(child:
          PatientOverview(initiallyExpanded: expanded, patient: patient)),
          ...children
        ]));
  }

  Widget _buildOverview(Patient patient) {
    return _buildTabView(patient, [], true);
  }

  Widget _buildActions(Patient patient) {
    return _buildTabView(
        patient,
        [
          ActionSelection(
              patient: patient,
              locations: [patient.location],
              refreshPatient: refresh)
        ],
        false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  _buildTab("Übersicht", ManvIcons.patient),
                  _buildTab("Maßnahmen", ManvIcons.action),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(AppLocalizations.of(context)!.patientScreenName),
            ),
            body: RefreshIndicator(
                onRefresh: () => refresh(null),
                child: ApiFutureBuilder<Patient>(
                    future: futurePatient,
                    builder: (context, patient) {
                      return TabBarView(
                        children: [
                          _buildOverview(patient),
                          _buildActions(patient),
                        ],
                      );
                    }))));
  }

  Future refresh(Patient? patient) {
    setState(() {
      // TODO necessary to leave before every arrival?
      futurePatient = patient != null
          ? Future(() => patient)
          : LocationService.leaveLocation()
              .then((v) => PatientService.arriveAtPatient(widget.patientId));
    });
    return futurePatient;
  }
}
