import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manvsim/models/conditions.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_overview.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/media_info.dart';
import 'package:manvsim/widgets/media_overview_expansion.dart';

import 'package:manvsim/constants/icons.dart' as icons;

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
        child:
            MediaOverviewExpansion(media: condition.media, children: [title]));
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm:ss').format(dateTime);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
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
                _formatDateTime(actionResult.performedAction.startTime),
                icons.Icons.time,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailEnd,
                _formatDateTime(endTime),
                icons.Icons.time,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailDuration,
                _formatDuration(actionResult.performedAction.action.duration),
                icons.Icons.duration,
                context),
            _buildDetailEntry(
                AppLocalizations.of(context)!.actionResultScreenDetailPlayer,
                actionResult.performedAction.playerTan,
                icons.Icons.user,
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
