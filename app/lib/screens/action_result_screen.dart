import 'package:flutter/material.dart';
import 'package:manvsim/models/conditions.dart';
import 'package:manvsim/widgets/action_overview.dart';
import 'package:manvsim/widgets/muti_media_view.dart';

import '../models/action_result.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionResultScreen extends StatefulWidget {
  final ActionResult actionResult;

  const ActionResultScreen({super.key, required this.actionResult});

  @override
  State<ActionResultScreen> createState() => _ActionResultScreenState();
}

class _ActionResultScreenState extends State<ActionResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  _buildConditionOverview(Condition condition) {
    Widget title = Text(
      condition.name,
      style: Theme.of(context).textTheme.bodyLarge,
    );

    return Card(
        child: condition.media.isEmpty
            ? Padding(padding: const EdgeInsets.all(8), child: title)
            : ExpansionTile(
                controlAffinity: ListTileControlAffinity.trailing,
                initiallyExpanded: true,
                shape: const Border(),
                childrenPadding: const EdgeInsets.only(left: 8.0),
                title: title,
                children: [
                  MultiMediaView(multiMediaCollection: condition.media),
                ],
              ));
  }

  _buildUsedResources() {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: (widget.actionResult.action.resourceNamesNeeded.isEmpty)
                    ? Text(
                        AppLocalizations.of(context)!.actionNoNeededResources)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: widget
                            .actionResult.action.resourceNamesNeeded.length,
                        itemBuilder: (context, index) {
                          return Text(widget
                              .actionResult.action.resourceNamesNeeded[index]);
                        },
                      ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Maßname Erfolgreich'),
        ),
        body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Card(
                    child: ActionOverview(
                        action: widget.actionResult.action,
                        patient: widget.actionResult.patient)),
                const Text('Verwendete Ressourcen'),
                _buildUsedResources(),
                const Text('Ergebnis(se)'),
                ListView.builder(
                  shrinkWrap: true, // nested scrolling
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.actionResult.conditions.length,
                  itemBuilder: (context, index) {
                    return _buildConditionOverview(
                        widget.actionResult.conditions[index]);
                  },
                ),
              ]),
            )));
  }
}
