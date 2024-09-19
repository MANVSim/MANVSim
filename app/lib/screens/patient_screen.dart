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
  bool sortOldestFirst = false;

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
                ElevatedButton(
                    onPressed: null,
                    child: Text(AppLocalizations.of(context)!
                        .patientScreenPerformedActionDetails)),
                MediaInfo(
                    title: performedAction.action.name,
                    media: performedAction.action.media)
              ]),
              const SizedBox(height: 8),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(ManvIcons.time, size: 20),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!
                      .patientScreenPerformedActionTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.right,
                  TimeService.formatDateTime(
                      performedAction.startTime, context),
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(ManvIcons.action, size: 20),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!
                      .patientScreenPerformedActionResults,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  performedAction.action.results.join(', '),
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
              ])
            ])));
  }

  PerformedActions sortedPerformedActions(Patient patient) {
    final performedActions = [...patient.performedActions];
    if (sortOldestFirst) {
      performedActions.sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      performedActions.sort((a, b) => b.startTime.compareTo(a.startTime));
    }
    return performedActions;
  }

  List<Widget> _buildPerformedActions(Patient patient) {
    if (patient.performedActions.isEmpty) {
      return [
        Card(
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child:
                        Text(AppLocalizations.of(context)!.patientScreenNoPerformedAction))))
      ];
    } else {
      return sortedPerformedActions(patient)
          .map((performedAction) => _buildPerformedAction(performedAction))
          .toList();
    }
  }

  void _sortOrderChanged(bool? ascending) {
    if (ascending == null) {
      return;
    }

    setState(() {
      sortOldestFirst = ascending;
    });
  }

  Widget _buildOverview(Patient patient) {
    return _buildTabView(
        patient,
        [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.patientScreenPerformedAction,
                  textAlign: TextAlign.center,
                ),
              ),
              if (patient.performedActions.length > 1)
                Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<bool>(
                            underline: Container(),
                            value: sortOldestFirst,
                            focusColor: Theme.of(context).dialogBackgroundColor,
                            icon: const Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.sort, size: 15)
                              ],
                            ),
                            items: [
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                    AppLocalizations.of(context)!.sortByNewest,
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  AppLocalizations.of(context)!.sortByOldest,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ],
                            onChanged: _sortOrderChanged,
                          ),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                    )),
            ],
          ),
          ..._buildPerformedActions(patient)
        ],
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
                  _buildTab(
                      AppLocalizations.of(context)!.patientScreenTabOverview,
                      ManvIcons.patient),
                  _buildTab(
                      AppLocalizations.of(context)!.patientScreenTabActions,
                      ManvIcons.action),
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
