import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/resource.dart';
import 'package:manvsim/screens/action_screen.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_card.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/resource_directory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionSelection extends StatefulWidget {
  final List<Location> locations;
  final Patient patient;
  final Function() refreshPatient;

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

  Iterable<Resource> resources = [];
  Iterable<PatientAction> possibleActions = [];
  List<PatientAction> notPossibleActions = [];

  toggleResource(Resource resource) {
    setState(() {
      resource.selected = !resource.selected;
    });
  }

  @override
  void initState() {
    resources = Location.flattenResourcesFromList(widget.locations);
    futureActions = ActionService.fetchActions();
    futureActions.then((actions) {
      // filter actions by available resources
      possibleActions = actions.where((action) => action.resourceNamesNeeded
          .every((resourceName) =>
              resources.any((resource) => resource.name == resourceName)));
      // Could be more efficient, but probably not needed here
      notPossibleActions =
          actions.where((action) => !possibleActions.contains(action)).toList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ApiFutureBuilder<List<PatientAction>>(
        future: futureActions,
        builder: (context, data) {
          var selectedActions = getSelectedActions();
          return Column(children: [
            Text(selectedActions.isNotEmpty
                ? AppLocalizations.of(context)!.patientActions
                : AppLocalizations.of(context)!.patientNoActions),
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
                itemCount: notPossibleActions.length,
                itemBuilder: (context, index) => ActionCard(
                      action: notPossibleActions[index],
                      patient: widget.patient,
                      canBePerformed: false,
                    )),
            Text(AppLocalizations.of(context)!.patientResources),
            ResourceDirectory(
                locations: widget.locations, resourceToggle: toggleResource),
          ]);
        },
      )
    ]);
  }

  List<PatientAction> getSelectedActions() {
    var selectedResources = getSelectedResources();
    if (selectedResources.isEmpty) {
      return possibleActions.toList();
    }
    return possibleActions
        .where((action) => selectedResources.every(
            (resource) => action.resourceNamesNeeded.contains(resource.name)))
        .toList();
  }

  Iterable<Resource> getSelectedResources() {
    return resources.where((r) => r.selected);
  }

  Iterable<Resource> getNeededResources(PatientAction action) {
    // quantity validation missing
    // TODO: rework
    var needed = List.from(action.resourceNamesNeeded);
    var selected = List.from(getSelectedResources());
    selected.removeWhere((s) => !needed.any((n) => s.name == n));
    needed.removeWhere((name) => selected.any((s) => s.name == name));
    for (var n in needed) {
      selected.add(resources.firstWhere((r) => r.name == n));
    }
    return getSelectedResources();
  }

  void performAction(PatientAction action) async {
    List<int> resourceIds =
        getNeededResources(action).map((resource) => resource.id).toList();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActionScreen(
                action: action,
                patient: widget.patient,
                resourceIds: resourceIds)));
    widget.refreshPatient();
  }
}
