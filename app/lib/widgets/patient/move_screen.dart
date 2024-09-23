import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/patient/move_overview.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';
import 'package:manvsim/widgets/util/timer_widget.dart';

import '../../models/location.dart';

class MoveScreen extends StatefulWidget {
  final Patient patient;
  final Location moveTo;

  const MoveScreen({
    super.key,
    required this.patient,
    required this.moveTo,
  });

  @override
  State<MoveScreen> createState() => _MoveScreenState();
}

class _MoveScreenState extends State<MoveScreen> {
  late Future<Patient?> futureMovedPatient;

  @override
  void initState() {
    super.initState();
    futureMovedPatient =
        PatientService.movePatient(widget.patient, widget.moveTo);
  }

  @override
  Widget build(BuildContext context) {
    const int waitTimeSeconds = 5;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.moveScreenTitle),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Card(child: MoveOverview(to: widget.moveTo, patient: widget.patient)),
          Expanded(
              child: Center(
                  child: CustomFutureBuilder<Patient>(
                      future: futureMovedPatient,
                      builder: (context, movedPatient) {
                        return TimerWidget(
                          duration: const Duration(seconds: waitTimeSeconds),
                          onTimerComplete: () => showResultDialog(
                              title: AppLocalizations.of(context)!
                                  .moveScreenDialogTitle,
                              content: successContent(),
                              movedPatient: movedPatient),
                        );
                      },
                      onError: (error) => Timer.run(() => showResultDialog(
                          title: AppLocalizations.of(context)!
                              .moveScreenDialogTitleError,
                          content: failureContent(error))))))
        ]));
  }

  void showResultDialog(
      {required Widget content, required String title, Patient? movedPatient}) {
    Future dialogFuture = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(title),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context), // close dialog
                child: Text(AppLocalizations.of(context)!.ok))
          ],
          content: content),
    );
    // close action_screen
    dialogFuture.whenComplete(() {
      Navigator.pop(context, movedPatient);
    });
  }

  Widget successContent() {
    return Text(AppLocalizations.of(context)!.moveScreenSuccess(
        widget.patient.name, widget.patient.location.name, widget.moveTo.name));
  }

  Widget failureContent(Object? error) {
    String errorText = error != null ? error.toString() : "";
    return Text("${AppLocalizations.of(context)!.moveFailure}\n\n$errorText");
  }
}
