import 'package:flutter/material.dart';
import 'package:manvsim/widgets/action_overview.dart';

import '../models/action_result.dart';


class ActionResultScreen extends StatefulWidget {
  final ActionResult actionResult;

  const ActionResultScreen({super.key, required this.actionResult});

  @override
  State<ActionResultScreen> createState() => _ActionResultScreenState();
}

class _ActionResultScreenState extends State<ActionResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Maßname Erfolgreich'),
      ),
      body: Column(children: [
        Card(
            child: ActionOverview(action: widget.actionResult.action, patient: widget.actionResult.patient))
      ]),
    );
  }
}
