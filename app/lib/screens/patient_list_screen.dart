import 'package:flutter/material.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/screens/patient_screen.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Patient>> futurePatientList;

  @override
  void initState() {
    futurePatientList = fetchPatientList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.patientListScreenName),
          actions: const <Widget>[LogoutButton()],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              futurePatientList = fetchPatientList();
            });
            return futurePatientList;
          },
          child: FutureBuilder<List<Patient>>(
              future: futurePatientList,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final patient = snapshot.data![index];
                    return Card(
                        child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(patient.name),
                      subtitle: Text(patient.injuries),
                      trailing: Text(patient.id.toString()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientScreen(patientId: patient.id)));
                      },
                    ));
                  },
                );
              }),
        ));
  }
}
