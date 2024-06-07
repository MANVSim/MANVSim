import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/screens/action_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionCard extends StatefulWidget {
  final PatientAction action;
  final Patient patient;
  final bool canBePerformed;

  const ActionCard(
      {super.key,
      required this.action,
      required this.patient,
      this.canBePerformed = false});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.canBePerformed
            ? Theme.of(context).cardTheme.color
            : Theme.of(context).disabledColor,
        child: ExpansionTile(
            title: Text(widget.action.name),
            controlAffinity: ListTileControlAffinity.leading,
            // removes border on top and bottom
            shape: const Border(),
            childrenPadding: const EdgeInsets.only(left: 8.0),
            children: [
              Row(children: [
                Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(AppLocalizations.of(context)!.actionNeededResources),
                      ListView.builder(
                          shrinkWrap: true, // nested scrolling
                          physics: const ClampingScrollPhysics(),
                          itemCount: widget.action.resourceNamesNeeded.length,
                          itemBuilder: (context, index) =>
                              Text(widget.action.resourceNamesNeeded[index]))
                    ])),
                if (widget.canBePerformed)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActionScreen(
                                    action: widget.action,
                                    patient: widget.patient)));
                      },
                      child: Text(AppLocalizations.of(context)!.actionPerform))
              ])
            ]));
  }
}
