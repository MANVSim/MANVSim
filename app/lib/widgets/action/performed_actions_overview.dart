import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/performed_actions.dart';
import 'package:manvsim/services/time_service.dart';
import 'package:manvsim/widgets/action/action_result_screen.dart';
import 'package:manvsim/widgets/media/media_info.dart';

class PerformedActionsOverview extends StatefulWidget {
  final Patient patient;
  final String title;
  const PerformedActionsOverview(
      {required this.patient, this.title = "", super.key});

  @override
  State<PerformedActionsOverview> createState() =>
      _PerformedActionsOverviewState();
}

class _PerformedActionsOverviewState extends State<PerformedActionsOverview> {
  bool sortOldestFirst = false;

  void _sortOrderChanged(bool? ascending) {
    if (ascending == null) {
      return;
    }
    setState(() {
      sortOldestFirst = ascending;
    });
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

  void _showActionResult(
      BuildContext context, PerformedAction performedAction, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionResultScreen(
          patient: patient,
          performedActionId: performedAction.id,
          resultAlreadyAvailable: true,
        ),
      ),
    );
  }

  List<Widget> _buildPerformedActions(Patient patient) {
    if (patient.performedActions.isEmpty) {
      return [
        Card(
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(AppLocalizations.of(context)!
                        .patientScreenNoPerformedAction))))
      ];
    } else {
      return sortedPerformedActions(patient)
          .map((performedAction) =>
              _buildPerformedAction(performedAction, patient))
          .toList();
    }
  }

  Widget _buildPerformedAction(
      PerformedAction performedAction, Patient patient) {
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
                    onPressed: () =>
                        _showActionResult(context, performedAction, patient),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(alignment: Alignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.patient.performedActions.length > 1)
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
                                style: Theme.of(context).textTheme.labelSmall),
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
        ]),
        ..._buildPerformedActions(widget.patient)
      ],
    );
  }
}
