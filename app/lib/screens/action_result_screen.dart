import 'package:flutter/material.dart';
import 'package:manvsim/models/conditions.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_overview.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/muti_media_view.dart';

import '../models/action_result.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/patient.dart';

class ActionResultScreen extends StatefulWidget {

  final Patient patient;
  final String performedActionId;
  final PatientAction performedAction;

  const ActionResultScreen({super.key, required this.patient, required this.performedActionId, required this.performedAction});

  @override
  State<ActionResultScreen> createState() => _ActionResultScreenState();
}

class _ActionResultScreenState extends State<ActionResultScreen> {

  late Future<ActionResult?> futureActionResult;

  @override
  void initState() {
    super.initState();
    futureActionResult = ActionService.fetchActionResult(
        widget.patient.id, widget.performedActionId, widget.performedAction);
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

  _buildUsedResources(List<String> resourceNamesNeeded) {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: (resourceNamesNeeded.isEmpty)
                    ? Text(
                        AppLocalizations.of(context)!.actionNoNeededResources)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: resourceNamesNeeded.length,
                        itemBuilder: (context, index) {
                          return Text(resourceNamesNeeded[index]);
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
              child: ApiFutureBuilder(future: this.futureActionResult, builder: (context, actionResult) {

                return Column(children: [
                  Card(
                      child: ActionOverview(
                          action: actionResult.action,
                          patient: actionResult.patient)),
                  const Text('Verwendete Ressourcen'),
                  _buildUsedResources(actionResult.action.resourceNamesNeeded),
                  const Text('Ergebnis(se)'),
                  ListView.builder(
                    shrinkWrap: true, // nested scrolling
                    physics: const ClampingScrollPhysics(),
                    itemCount: actionResult.conditions.length,
                    itemBuilder: (context, index) {
                      return _buildConditionOverview(
                          actionResult.conditions[index]);
                    },
                  ),
                ]);



              },),
            )));
  }
}
