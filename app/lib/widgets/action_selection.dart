import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/screens/action_screen.dart';
import 'package:manvsim/widgets/resource_directory.dart';

class ActionSelection extends StatefulWidget {
  final List<Location> locations;
  final List<PatientAction> actions;

  const ActionSelection(
      {super.key, required this.locations, required this.actions});

  @override
  State<ActionSelection> createState() => _ActionSelectionState();
}

class _ActionSelectionState extends State<ActionSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ResourceDirectory(locations: widget.locations),
      const Text('Actions: '),
      ListView.builder(
        shrinkWrap: true, // nested scrolling
        physics: const ClampingScrollPhysics(),
        itemCount: widget.actions.length,
        itemBuilder: (context, index) => Card(
            child: ListTile(
                title: Text(widget.actions[index].name),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActionScreen(action: widget.actions[index])));
                })),
      )
    ]);
  }
}
