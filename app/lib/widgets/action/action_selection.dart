import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/resource.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/services/size_service.dart';
import 'package:manvsim/widgets/action/action_card.dart';
import 'package:manvsim/widgets/action/action_screen.dart';
import 'package:manvsim/widgets/location/move_card.dart';
import 'package:manvsim/widgets/location/resource_directory.dart';
import 'package:manvsim/widgets/patient/move_screen.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';

import '../../services/location_service.dart';

class ActionSelection extends StatefulWidget {
  final List<Location> locations;
  final Patient patient;
  final Function(Patient?) refreshPatient;

  const ActionSelection(
      {super.key,
      required this.locations,
      required this.patient,
      required this.refreshPatient});

  @override
  State<ActionSelection> createState() => _ActionSelectionState();
}

class _ActionSelectionState extends State<ActionSelection> {
  late Future<List<PatientAction>> futureActions;
  late Future<List<Location>?> futureLocationIdList;

  Iterable<Resource> resources = [];
  Iterable<PatientAction> possibleActions = [];
  List<PatientAction> notPossibleActions = [];

  toggleResource(Resource resource) {
    setState(() {
      resource.selected = !resource.selected;
      resources; // To update the view
    });
  }

  @override
  void initState() {
    resources = Location.flattenResourcesFromList(widget.locations);
    futureActions = ActionService.fetchActions();
    futureLocationIdList = LocationService.fetchLocations();
    super.initState();
  }

  void setActions(List<PatientAction> actions) {
    // filter actions by available resources
    possibleActions = actions.where((action) => action.resourceNamesNeeded
        .every((resourceName) => resources.any((resource) =>
            (resource.name == resourceName && resource.quantity > 0))));
    // Could be more efficient, but probably not needed here
    notPossibleActions =
        actions.where((action) => !possibleActions.contains(action)).toList();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.patientScreenFilterResourceTitle),
            content: SizedBox(
                width: SizeService.getScreenWidth(context) * 0.8,
                child: ResourceDirectory(
                  initiallyExpanded: true,
                  locations: widget.locations,
                  resourceToggle: (resource) {
                    toggleResource(resource);
                    setStateDialog(() {});
                  },
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.dialogueClose),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    resources = Location.flattenResourcesFromList(widget.locations);

    return Column(children: [
      CustomFutureBuilder<List<PatientAction>>(
        future: futureActions,
        builder: (context, actions) {
          setActions(actions);
          var selectedActions = getSelectedActions(possibleActions.toList());
          var notPossibleActionsSelected =
              getSelectedActions(notPossibleActions);
          return Column(children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.patientActions,
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => _showFilterDialog(context),
                    icon: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
            if (getSelectedResources().isNotEmpty) ...[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 4.0,
                children: getSelectedResources().map((resource) {
                  return Chip(
                    label: Text(resource.name),
                    onDeleted: () => toggleResource(resource),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
            if (selectedActions.isEmpty)
              Card(
                  child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(AppLocalizations.of(context)!
                              .patientNoActions)))),
            ListView.builder(
                shrinkWrap: true, // nested scrolling
                physics: const ClampingScrollPhysics(),
                itemCount: selectedActions.length,
                itemBuilder: (context, index) => ActionCard(
                      action: selectedActions[index],
                      patient: widget.patient,
                      canBePerformed: true,
                      onPerform: () => performAction(selectedActions[index]),
                    )),
            ListView.builder(
                // TODO show which resource you do have
                shrinkWrap: true, // nested scrolling
                physics: const ClampingScrollPhysics(),
                itemCount: notPossibleActionsSelected.length,
                itemBuilder: (context, index) => ActionCard(
                      action: notPossibleActionsSelected[index],
                      patient: widget.patient,
                      canBePerformed: false,
                    )),
            Text(AppLocalizations.of(context)!.patientMoveSection),
            CustomFutureBuilder(
                future: futureLocationIdList,
                builder: (context, locations) => MoveCard(
                    locations: locations
                        .where((location) =>
                            location.id != widget.patient.location.id)
                        .toList(),
                    onPerform: movePatient)),
          ]);
        },
      )
    ]);
  }

  List<PatientAction> getSelectedActions(List<PatientAction> actions) {
    var selectedResources = getSelectedResources();
    if (selectedResources.isEmpty) {
      return actions;
    }
    return actions
        .where((action) => selectedResources.every(
            (resource) => action.resourceNamesNeeded.contains(resource.name)))
        .toList();
  }

  Iterable<Resource> getSelectedResources() {
    return resources.where((r) => r.selected);
  }

  /// Returns all resources needed for a possible [action] using [getSelectedResources] and auto selecting the missing ones.
  Iterable<Resource> getNeededResources(PatientAction action) {
    // TODO: quantity validation, maybe rework
    List<String> needed = List.from(action.resourceNamesNeeded);
    List<Resource> selected = List.from(getSelectedResources());
    selected.removeWhere((s) => needed.every((name) => s.name != name));
    needed.removeWhere((name) => selected.any((s) => s.name == name));
    for (String name in needed) {
      selected.add(resources.firstWhere((r) => r.name == name));
    }
    return selected;
  }

  /// Navigates to [ActionScreen] and tries to perform [action].
  void performAction(PatientAction action) async {
    List<int> resourceIds =
        getNeededResources(action).map((resource) => resource.id).toList();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActionScreen(
              onActionPerformed: widget.refreshPatient,
                action: action,
                patient: widget.patient,
                resourceIds: resourceIds)));
  }

  void movePatient(Location moveTo) async {
    Patient? movedPatient = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MoveScreen(patient: widget.patient, moveTo: moveTo)));

    widget.refreshPatient(movedPatient);
  }
}
