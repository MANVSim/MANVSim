import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';

import 'package:manvsim/models/patient_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:manvsim/constants/manv_icons.dart';

import 'media_overview_dialog.dart';

class ActionCard extends StatefulWidget {
  final PatientAction action;
  final Patient patient;
  final bool canBePerformed;
  final Function()? onPerform;

  const ActionCard(
      {super.key,
      required this.action,
      required this.patient,
      this.canBePerformed = false,
      this.onPerform});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.canBePerformed
            ? Theme.of(context).cardTheme.color
            : Theme.of(context).disabledColor.withOpacity(0.2),
        child: ExpansionTile(
          initiallyExpanded: true,
            title: Text(widget.action.name),
            trailing: (widget.action.media.isNotEmpty)
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => MediaOverViewDialog(
                              title: widget.action.name,
                              media: widget.action.media));
                    },
                    icon: const Icon(ManvIcons.info))
                : null,
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
                      Text(widget.action.resourceNamesNeeded.isNotEmpty
                          ? AppLocalizations.of(context)!.actionNeededResources
                          : AppLocalizations.of(context)!
                              .actionNoNeededResources),
                      ListView.builder(
                          shrinkWrap: true, // nested scrolling
                          physics: const ClampingScrollPhysics(),
                          itemCount: widget.action.resourceNamesNeeded.length,
                          itemBuilder: (context, index) =>
                              Text(widget.action.resourceNamesNeeded[index]))
                    ])),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen),
                    onPressed: widget.canBePerformed ? widget.onPerform : null,
                    child: Text(AppLocalizations.of(context)!.actionPerform))
              ])
            ]));
  }
}
