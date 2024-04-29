import 'package:flutter/material.dart';
import 'dart:convert';

class Patient {
  final int id;
  String description;

  Patient({
    required this.id,
    required this.description
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'description': String description} =>
          Patient(id: id, description: description),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }
}

Future<List<Patient>> fetchPatientList() async {
  String json = demoJson;//await File("patients.json").readAsString();
  List<dynamic> jsonList = jsonDecode(json);
  return jsonList.map((patient) => Patient.fromJson(patient)).toList();
}

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
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

const String demoJson = """
[
  {"id": 1, "description": "Max Mustermann"},
  {"id": 2, "description": "Bernd Beispiel"},
  {"id": 3, "description": "Patient 3"},
  {"id": 4, "description": "Bein fehlt"}
]""";