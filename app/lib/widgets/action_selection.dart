import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/resource.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_card.dart';
import 'package:manvsim/widgets/resource_directory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionSelection extends StatefulWidget {
  final Patient patient;

  const ActionSelection({super.key, required this.patient});

  @override
  State<ActionSelection> createState() => _ActionSelectionState();
}

class _ActionSelectionState extends State<ActionSelection> {
  late Future<List<Location>> futureLocations;
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
    futureLocations = fetchLocations();
    futureLocations.then((locations) {
      resources = Location.flattenResourcesFromList(locations);
    });
    futureActions = fetchActions();
    futureActions.then((actions) {
      futureLocations.then((locations) {
        // filter actions by available resources
        possibleActions = actions.where((action) => action.resourceNamesNeeded
            .every((resourceName) =>
                resources.any((resource) => resource.name == resourceName)));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(AppLocalizations.of(context)!.patientResources),
      FutureBuilder(
        future: futureLocations,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ResourceDirectory(
                locations: snapshot.data!, resourceToggle: toggleResource);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      Text(AppLocalizations.of(context)!.patientActions),
      FutureBuilder(
        future: futureActions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var selectedActions = getSelectedActions();
            return Column(children: [
              ListView.builder(
                  shrinkWrap: true, // nested scrolling
                  physics: const ClampingScrollPhysics(),
                  itemCount: selectedActions.length,
                  itemBuilder: (context, index) => ActionCard(
                      action: selectedActions[index],
                      patient: widget.patient,
                      canBePerformed: true)),
              ListView.builder(
                  shrinkWrap: true, // nested scrolling
                  physics: const ClampingScrollPhysics(),
                  itemCount: notPossibleActions.length,
                  itemBuilder: (context, index) => ActionCard(
                      action: notPossibleActions[index],
                      patient: widget.patient,
                      canBePerformed: false)),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
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
}
