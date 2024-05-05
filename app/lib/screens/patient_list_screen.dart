import 'package:flutter/material.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> patientList;

  Future<void> _updatePatientList() async {
    setState(() {
      patientList = fetchPatientList();
    });
  }

  @override
  void initState() {
    super.initState();
    patientList = fetchPatientList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("List of patients"),
        ),
        body: RefreshIndicator(
          onRefresh: _updatePatientList,
          child: FutureBuilder<List<Patient>>(
              future: patientList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (BuildContext, int index) => const Divider(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final patient = snapshot.data![index];
                      return ListTile(
                        title: Text(patient.id.toString()),
                        subtitle: Text(patient.description),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
        )
    );
  }
}