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
  late Future<List<int>?> futurePatientTanList;

  @override
  void initState() {
    futurePatientTanList = PatientService.fetchPatientsTans();
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
              futurePatientTanList = PatientService.fetchPatientsTans();
            });
            return futurePatientTanList;
          },
          child: FutureBuilder<List<int>?>(
              future: futurePatientTanList,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                var patientTanList = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: patientTanList.length,
                    itemBuilder: (context, index) => Card(
                            child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(patientTanList[index].toString()),
                          // TODO
                          //trailing: Text(patient.id.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PatientScreen(
                                        patientId: patientTanList[index])));
                          },
                        )));
              }),
        ));
  }
}
