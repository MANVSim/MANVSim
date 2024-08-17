import 'dart:async';


import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/timer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/location.dart';

class MoveScreen extends StatefulWidget {
  final Patient patient;
  final Location moveTo;

  const MoveScreen(
      {super.key,
      required this.patient,
      required this.moveTo,});

  @override
  State<MoveScreen> createState() => _MoveScreenState();
}

class _MoveScreenState extends State<MoveScreen> {
  late Future<Duration> futureDuration;

  @override
  void initState() {
    super.initState();
    futureDuration = PatientService.movePatient(widget.patient, widget.moveTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title:  Text(AppLocalizations.of(context)!.moveScreenTitle(
              widget.patient.name,
              widget.patient.location.name,
              widget.moveTo.name)),
          actions: const <Widget>[LogoutButton()],
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: ApiFutureBuilder<Duration>(
                future:  futureDuration,
                builder: (context, waitTime) {
                  return TimerWidget(
                    duration: waitTime,
                    onTimerComplete: () =>
                        showResultDialog(successContent()),
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
          title:  Text(AppLocalizations.of(context)!.moveScreenTitle(
              widget.patient.name,
              widget.patient.location.name,
              widget.moveTo.name)),
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

  Widget successContent() {
    return Text(AppLocalizations.of(context)!.moveScreenSuccess(        widget.patient.name,
        widget.patient.location.name,
        widget.moveTo.name));
  }

  Widget failureContent() {
    return Text(AppLocalizations.of(context)!.moveFailure);
  }
}
