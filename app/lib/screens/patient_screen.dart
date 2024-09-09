import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/patient_overview.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/manv_icons.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;

  const PatientScreen({super.key, required this.patientId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> with SingleTickerProviderStateMixin{
  late Future<Patient?> futurePatient;

  late TabController _tabController;
  late ExpansionTileController _overviewExpansionController;


  @override
  void initState() {

    futurePatient = PatientService.arriveAtPatient(widget.patientId);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    _overviewExpansionController = ExpansionTileController();

    super.initState();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      refresh(null);
      if (_tabController.index == 0){
        _overviewExpansionController.expand();
      } else {
        _overviewExpansionController.collapse();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
              bottom:  TabBar(
                controller: _tabController,
                tabs: [
                  _buildTab("Übersicht", ManvIcons.patient),
                  _buildTab("Maßnahmen", ManvIcons.action),
                ],
              ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!
              .patientScreenName),
        ),
        body: RefreshIndicator(
            onRefresh: () => refresh(null),
            child: ApiFutureBuilder<Patient>(
                future: futurePatient,
                builder: (context, patient) {
                  return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        Card(
                            child: PatientOverview(
                                expansionController:
                                    _overviewExpansionController,
                                patient: patient)),
                        ActionSelection(
                            patient: patient,
                            locations: [patient.location],
                            refreshPatient: refresh)
                      ]));
                })));
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
