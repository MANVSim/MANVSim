import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/action_selection.dart';
import 'package:manvsim/widgets/patient_overview.dart';
import 'package:manvsim/widgets/logout_button.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  const PatientScreen({super.key, required this.patient});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late List<Location> locations;
  late List<PatientAction> actions;

  late Future<void> loading;

  Future _updateActions() async {
    return Future.wait([
      fetchLocations().then((value) => locations = value),
      fetchActions().then((value) => actions = value)
    ]);
  }

  @override
  void initState() {
    super.initState();
    loading = _updateActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Patient: ${widget.patient.id.toString()} '),
          actions: const <Widget>[LogoutButton()],
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return _updateActions();
            },
            child: SingleChildScrollView(
                child: Column(children: [
              PatientOverview(patient: widget.patient),
              FutureBuilder(
                  future: loading,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ActionSelection(
                        locations: locations,
                        actions: actions,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  })
            ]))));
  }
}
