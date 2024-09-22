import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action/action_overview.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';
import 'package:manvsim/widgets/util/timer_widget.dart';

import 'action_result_screen.dart';

class ActionScreen extends StatefulWidget {
  final PatientAction action;
  final Patient patient;
  final List<int> resourceIds;

  const ActionScreen(
      {super.key,
      required this.action,
      required this.patient,
      required this.resourceIds});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  late Future<String?> futureActionId;

  late bool _hasError;
  Patient? patient;

  @override
  void initState() {
    futureActionId = ActionService.performAction(
        widget.patient.id, widget.action.id, widget.resourceIds);
    _hasError = false;
    super.initState();
  }

  void onTimerComplete(String actionId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActionResultScreen(
            patient: widget.patient, performedActionId: actionId),
      ),
    );
  }

  void onError() {
    Timer.run(() {
      setState(() {
        _hasError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(AppLocalizations.of(context)!
              .actionScreenTitle(widget.patient.name, widget.action.name)),
          automaticallyImplyLeading: _hasError,
        ),
        body: Column(
          children: [
            Card(
              child: ActionOverview(
                action: widget.action,
                patient: widget.patient,
                showMediaInfo: false,
              ),
            ),
            Expanded(
                child: Center(
                    child: CustomFutureBuilder<String>(
                        future: futureActionId,
                        onErrorNotify: (error) => onError(),
                        builder: (context, actionId) {
                          return TimerWidget(
                            duration: widget.action.duration,
                            onTimerComplete: () => onTimerComplete(actionId),
                          );
                        })))
          ],
        ));
  }
}
