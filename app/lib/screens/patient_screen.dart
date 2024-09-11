import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/performed_actions.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/services/time_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/media_info.dart';
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
          Card(
              child: PatientOverview(
                  initiallyExpanded: expanded, patient: patient)),
          ...children
        ]));
  }

  Widget _buildPerformedAction(PerformedAction performedAction) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  performedAction.action.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                ElevatedButton(onPressed: null, child: Text(AppLocalizations.of(context)!.patientScreenPerformedActionDetails)),
                MediaInfo(title: performedAction.action.name, media: performedAction.action.media)
              ]),
              const SizedBox(height: 8),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(ManvIcons.time, size: 20),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.patientScreenPerformedActionTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.right,
                  TimeService.formatDateTime(performedAction.startTime, context),
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(ManvIcons.user, size: 20),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.patientScreenPerformedActionPlayer,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.right,
                  performedAction.playerTan,
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
              ])
            ])));
  }

  List<Widget> _buildPerformedActions(Patient patient) {
    return patient.performedActions
        .map((performedAction) => _buildPerformedAction(performedAction))
        .toList();
  }

  Widget _buildOverview(Patient patient) {
    return _buildTabView(
        patient,
        [Text(AppLocalizations.of(context)!.patientScreenPerformedAction), ..._buildPerformedActions(patient)],
        true);
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
                  _buildTab(AppLocalizations.of(context)!.patientScreenTabOverview, ManvIcons.patient),
                  _buildTab(AppLocalizations.of(context)!.patientScreenTabActions, ManvIcons.action),
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
      futurePatient = patient != null
          ? Future(() => patient)
          : LocationService.leaveLocation()
              .then((v) => PatientService.arriveAtPatient(widget.patientId));
    });
    return futurePatient;
  }
}
