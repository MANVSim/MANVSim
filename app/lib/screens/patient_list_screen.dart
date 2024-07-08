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
  late Future<List<int>?> futurePatientIdList;

  @override
  void initState() {
    futurePatientIdList = PatientService.fetchPatientsIDs();
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
              futurePatientIdList = PatientService.fetchPatientsIDs();
            });
            return futurePatientIdList;
          },
          child: FutureBuilder<List<int>?>(
              future: futurePatientIdList,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                var patientIds = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: patientIds.length,
                    itemBuilder: (context, index) => Card(
                            child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(patientIds[index].toString()),
                          // TODO
                          //trailing: Text(patient.id.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PatientScreen(
                                        patientId: patientIds[index])));
                          },
                        )));
              }),
        ));
  }
}
