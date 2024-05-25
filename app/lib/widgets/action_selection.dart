import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/resource.dart';
import 'package:manvsim/screens/action_screen.dart';
import 'package:manvsim/widgets/resource_directory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionSelection extends StatefulWidget {
  final List<Location> locations;
  final List<PatientAction> actions;

  const ActionSelection(
      {super.key, required this.locations, required this.actions});

  @override
  State<ActionSelection> createState() => _ActionSelectionState();
}

class _ActionSelectionState extends State<ActionSelection> {
  late final Iterable<Resource> resources;
  late final Iterable<PatientAction> possibleActions;

  toggleResource(Resource resource) {
    setState(() {
      resource.selected = !resource.selected;
    });
  }

  @override
  void initState() {
    resources = Location.flattenResourcesFromList(widget.locations);
    // filter actions by available resources
    possibleActions = widget.actions.where((action) =>
        action.resourceNamesNeeded.every((resourceName) =>
            resources.any((resource) => resource.name == resourceName)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedActions = getSelectedActions();
    return Column(children: [
      const Text('Resources: '),
      ResourceDirectory(
          locations: widget.locations, resourceToggle: toggleResource),
      Text(AppLocalizations.of(context)!.patientActions),
      ListView.builder(
        shrinkWrap: true, // nested scrolling
        physics: const ClampingScrollPhysics(),
        itemCount: selectedActions.length,
        itemBuilder: (context, index) => Card(
            child: ListTile(
                title: Text(selectedActions[index].name),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActionScreen(action: selectedActions[index])));
                })),
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
}
