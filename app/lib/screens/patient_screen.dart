import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/action_service.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/resource_directory.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  const PatientScreen({super.key, required this.patient});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late Future<List<Location>> locations;

  Future<void> _updateActions() async {
    setState(() {
      locations = fetchActions();
    });
  }

  @override
  void initState() {
    super.initState();
    locations = fetchActions();
  }

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
              return _updateActions();
            },
            child: Column(children: [
              const Placeholder(),
              FutureBuilder(
                  future: locations,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ResourceDirectory(locations: snapshot.data!));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  })
            ])
        )
    );
  }
}
