import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/conditions.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/services/time_service.dart';
import 'package:manvsim/widgets/action/action_overview.dart';
import 'package:manvsim/widgets/media/media_info.dart';
import 'package:manvsim/widgets/media/media_overview_expansion.dart';
import 'package:manvsim/widgets/util/api_future_builder.dart';

import '../../models/action_result.dart';
import '../../models/patient.dart';
import '../../models/resource.dart';

class ActionResultScreen extends StatefulWidget {
  final Patient patient;
  final String performedActionId;
  final bool resultAlreadyAvailable;

  const ActionResultScreen(
      {super.key,
      required this.patient,
      required this.performedActionId,
      this.resultAlreadyAvailable = false});

  @override
  State<ActionResultScreen> createState() => _ActionResultScreenState();
}

class _ActionResultScreenState extends State<ActionResultScreen> {
  late Future<ActionResult?> futureActionResult;

  @override
  void initState() {
    super.initState();

    futureActionResult = widget.resultAlreadyAvailable
        ? Future.value(
            ActionResult.fromPatient(widget.patient, widget.performedActionId))
        : ActionService.fetchActionResult(
            widget.patient, widget.performedActionId);
  }

  _buildConditionOverview(Condition condition) {
    Widget title = Text(
      condition.name,
      style: Theme.of(context).textTheme.bodyLarge,
    );

    return Card(
        child:
            MediaOverviewExpansion(media: condition.media, children: [title]));
  }

  _buildDetailEntry(
      String key, String value, IconData icon, BuildContext context) {
    return Row(children: [
      Icon(icon),
      const SizedBox(width: 8),
      Text(key, style: Theme.of(context).textTheme.bodyMedium),
      Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium)),
    ]);
  }

  _buildDetails(ActionResult actionResult, BuildContext context) {
    DateTime endTime = actionResult.performedAction.startTime
        .add(actionResult.performedAction.action.duration);

    return Card(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailStart,
                TimeService.formatDateTime(
                    actionResult.performedAction.startTime, context),
                ManvIcons.time,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailEnd,
                TimeService.formatDateTime(endTime, context),
                ManvIcons.time,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailDuration,
                TimeService.formatDuration(
                    actionResult.performedAction.action.duration),
                ManvIcons.duration,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailPlayer,
                actionResult.performedAction.playerTan,
                ManvIcons.user,
                context),
          ],
        ),
      ),
    ));
  }

  _buildUsedResources(List<Resource> resources) {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(16),
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
          title: Text(AppLocalizations.of(context)!.actionResultScreenTitle),
        ),
        body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ApiFutureBuilder(
                future: futureActionResult,
                builder: (context, actionResult) {
                  return Column(children: [
                    Card(
                        child: ActionOverview(
                            action: actionResult.performedAction.action,
                            patient: actionResult.patient)),
                    Text(AppLocalizations.of(context)!
                        .actionResultScreenDetails),
                    _buildDetails(actionResult, context),
                    Text(AppLocalizations.of(context)!
                        .actionResultScreenUsedResources),
                    _buildUsedResources(actionResult.performedAction.resources),
                    Text(AppLocalizations.of(context)!
                        .actionResultScreenResults),
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
