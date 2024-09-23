import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action/action_selection.dart';
import 'package:manvsim/widgets/action/performed_actions_overview.dart';
import 'package:manvsim/widgets/patient/classification_card.dart';
import 'package:manvsim/widgets/patient/patient_overview.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';

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

  Future refresh([Patient? patient]) {
    setState(() {
      futurePatient = patient != null
          ? Future(() => patient)
          : PatientService.refreshPatient(widget.patientId);
    });
    return futurePatient;
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
    return RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Card(
                  child: PatientOverview(
                      initiallyExpanded: expanded, patient: patient)),
              ...children
            ])));
  }

  Widget _buildOverview(Patient patient) {
    return _buildTabView(
        patient,
        [
          Text(
            AppLocalizations.of(context)!.patientScreenClassification,
            textAlign: TextAlign.center,
          ),
          ClassificationCard(patient: patient),
          const SizedBox(height: 4),
          PerformedActionsOverview(
              patient: patient,
              title: AppLocalizations.of(context)!.patientScreenPerformedAction)
        ],
        true);
  }

  Widget _buildActions(Patient patient) {
    return _buildTabView(
        patient,
        [
          Text(AppLocalizations.of(context)!.patientScreenClassification),
          ClassificationCard(patient: patient, changeable: true),
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
                    _buildTab(
                        AppLocalizations.of(context)!.patientScreenTabOverview,
                        ManvIcons.patient),
                    _buildTab(
                        AppLocalizations.of(context)!.patientScreenTabActions,
                        ManvIcons.action),
                  ],
                ),
                title: Text(AppLocalizations.of(context)!.patientScreenName),
                actions: [
                  if (kIsWeb)
                    IconButton(
                        onPressed: refresh, icon: const Icon(ManvIcons.refresh))
                ]),
            body: CustomFutureBuilder<Patient>(
                future: futurePatient,
                builder: (context, patient) {
                  return TabBarView(
                    children: [
                      _buildOverview(patient),
                      _buildActions(patient),
                    ],
                  );
                })));
  }
}
