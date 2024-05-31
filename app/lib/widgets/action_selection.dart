import 'package:flutter/cupertino.dart';
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
  Set<Resource> selectedResources = {};

  toggleResource(Resource resource) {
    setState(() {
      // Try to remove, else wasn't in set and add
      if (!selectedResources.remove(resource)) {
        selectedResources.add(resource);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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

  List<PatientAction> get selectedActions {
    if (selectedResources.isEmpty) {
      return widget.actions;
    }
    return widget.actions
        .where((action) => selectedResources.every(
            (resource) => action.resourceNamesNeeded.contains(resource.name)))
        .toList();
  }
}
