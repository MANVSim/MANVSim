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

  const ActionScreen({super.key, required this.action, required this.patient});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  late Future<int> futureActionId;
  late Future<String> futureResult;

  @override
  void initState() {
    futureActionId = performAction(widget.action.id, []); // TODO
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
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() => null);
            },
            child: Center(
                child: FutureBuilder<int>(
                    future: futureActionId,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TimerWidget(
                          duration: widget.action.durationInSeconds,
                          onTimerComplete: () =>
                              showResultDialog(successContent(snapshot.data!)),
                        );
                      } else if (snapshot.hasError) {
                        Timer.run(() => showResultDialog(failureContent()));
                      }
                      return const Center(child: CircularProgressIndicator());
                    }))));
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

  Widget successContent(int performedActionId) {
    futureResult = fetchActionResult(performedActionId);
    return FutureBuilder<String>(
        future: futureResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        });
  }

  Widget failureContent() {
    return Text(AppLocalizations.of(context)!.actionFailure);
  }
}
