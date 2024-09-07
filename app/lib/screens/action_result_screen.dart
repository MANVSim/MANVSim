import 'package:flutter/material.dart';
import 'package:manvsim/models/conditions.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_overview.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/media_info.dart';
import 'package:manvsim/widgets/muti_media_view.dart';

import '../models/action_result.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/patient.dart';
import '../models/resource.dart';

class ActionResultScreen extends StatefulWidget {
  final Patient patient;
  final String performedActionId;

  const ActionResultScreen(
      {super.key, required this.patient, required this.performedActionId});

  @override
  State<ActionResultScreen> createState() => _ActionResultScreenState();
}

class _ActionResultScreenState extends State<ActionResultScreen> {
  late Future<ActionResult?> futureActionResult;

  @override
  void initState() {
    super.initState();
    futureActionResult = ActionService.fetchActionResult(
        widget.patient, widget.performedActionId);
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

  _buildUsedResources(List<Resource> resources) {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: (resources.isEmpty)
                    ? Text(
                        AppLocalizations.of(context)!.actionNoNeededResources)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: resources.length,
                        itemBuilder: (context, index) {
                          Resource currentResource = resources[index];
                          return Row(
                            children: [
                              Expanded(
                                  child: Text(currentResource.name,
                                      overflow: TextOverflow.ellipsis)),
                              Text(currentResource.quantity.toString()),
                              SizedBox(
                                  width: 40,
                                  child: (currentResource.media.isNotEmpty)
                                      ? MediaInfo(
                                          title: currentResource.name,
                                          media: currentResource.media)
                                      : null),
                            ],
                          );
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
              child: ApiFutureBuilder(
                future: this.futureActionResult,
                builder: (context, actionResult) {
                  return Column(children: [
                    Card(
                        child: ActionOverview(
                            action: actionResult.performedAction.action,
                            patient: actionResult.patient)),
                    const Text('Verwendete Ressourcen'),
                    _buildUsedResources(actionResult.performedAction.resources),
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
                },
              ),
            )));
  }
}
