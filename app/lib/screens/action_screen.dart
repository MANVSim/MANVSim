import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/types.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/timer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Future<ConditionPatient?> futureResult;
  Patient? patient;

  @override
  void initState() {
    futureActionId = ActionService.performAction(
        widget.patient.id, widget.action.id, widget.resourceIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!
              .actionScreenTitle(widget.patient.name, widget.action.name)),
          actions: const <Widget>[LogoutButton()],
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: ApiFutureBuilder<String>(
                future: futureActionId,
                builder: (context, actionId) {
                  return TimerWidget(
                    duration: widget.action.durationInSeconds,
                    onTimerComplete: () =>
                        showResultDialog(successContent(actionId)),
                  );
                },
                onError: () =>
                    Timer.run(() => showResultDialog(failureContent())))));
  }

  void showResultDialog(Widget content) {
    Future dialogFuture = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .actionScreenTitle(widget.patient.name, widget.action.name)),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context), // close dialog
                child: Text(AppLocalizations.of(context)!.ok))
          ],
          content: content),
    );
    // close action_screen
    dialogFuture.whenComplete(() {
      Navigator.pop(context, patient);
    });
  }

  Widget successContent(String performedActionId) {
    futureResult =
        ActionService.fetchActionResult(widget.patient.id, performedActionId);
    return ApiFutureBuilder<ConditionPatient>(
        future: futureResult,
        builder: (context, conditionPatient) {
          var (condition, patient) = conditionPatient;
          this.patient = patient;
          var conditionList = condition.entries.toList();
          return ListView.builder(
              shrinkWrap: true, // nested scrolling
              physics: const ClampingScrollPhysics(),
              itemCount: conditionList.length,
              itemBuilder: (context, index) => Row(children: [
                    Text("${conditionList[index].key}: ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(conditionList[index].value)
                  ]));
        });
  }

  Widget failureContent() {
    return Text(AppLocalizations.of(context)!.actionFailure);
  }
}
