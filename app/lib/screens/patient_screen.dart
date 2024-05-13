import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/widgets/logout_button.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  const PatientScreen({super.key, required this.patient});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.patient.description),
          actions: const <Widget>[LogoutButton()],
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() => null);
            },
            child: const Column(children: [
              Placeholder(),
              Column(
                children: [
                  const ExpansionTile(
                    title: Text('Red backpack'),
                    subtitle: Text('Everything you need quick access to'),
                    children: <Widget>[
                      ListTile(title: Text('Something directly in backpack')),
                      const ExpansionTile(
                        title: Text('Medication pack'),
                        subtitle: Text('Medicine'),
                        children: <Widget>[
                          ListTile(title: Text('Pain killer')),
                        ],
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text('RTW'),
                    subtitle: Text('Everything on the RTW'),
                    children: <Widget>[
                      ListTile(title: Text('EKG')),
                      const ExpansionTile(
                        title: Text('Medicine cabinet'),
                        subtitle: Text('Medicine'),
                        children: <Widget>[
                          ListTile(title: Text('Strong pain killer')),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ])));
  }
}
