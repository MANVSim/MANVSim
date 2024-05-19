import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/widgets/logout_button.dart';

class ActionScreen extends StatefulWidget {
  final PatientAction action;

  const ActionScreen({super.key, required this.action});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  late Timer timer;
  late int countdownInSeconds;

  @override
  void initState() {
    super.initState();
    countdownInSeconds = widget.action.durationInSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdownInSeconds == 0) {
          timer.cancel();
        } else {
          countdownInSeconds--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.action.name),
          actions: const <Widget>[LogoutButton()],
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() => null);
            },
            child: Column(children: [
              Text(
                formattedCountdown,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                  )),
              const Placeholder()
            ])));
  }

  double get progress {
    return (widget.action.durationInSeconds - countdownInSeconds) /
        widget.action.durationInSeconds;
  }

  String get formattedCountdown {
    return '${countdownInSeconds ~/ 60}:${countdownInSeconds % 60}';
  }
}
