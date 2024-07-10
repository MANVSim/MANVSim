import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/services/action_service.dart';
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
  late Future<String?> futureResult;

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
            child: FutureBuilder<String?>(
                future: futureActionId,
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    Timer.run(() => showResultDialog(failureContent()));
                  } else if (!snapshot.hasData ||
                      snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TimerWidget(
                    duration: widget.action.durationInSeconds,
                    onTimerComplete: () =>
                        showResultDialog(successContent(snapshot.data!)),
                  );
                })));
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
      Navigator.pop(context);
    });
  }

  Widget successContent(String performedActionId) {
    futureResult =
        ActionService.fetchActionResult(widget.patient.id, performedActionId);
    return FutureBuilder<String?>(
        future: futureResult,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('${snapshot.error}');
          } else if (!snapshot.hasData ||
              snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Text(snapshot.data!);
        });
  }

  Widget failureContent() {
    return Text(AppLocalizations.of(context)!.actionFailure);
  }
}
