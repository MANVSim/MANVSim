import 'package:flutter/material.dart';

import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:manvsim/constants/manv_icons.dart';

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
          child: ApiFutureBuilder<List<int>>(
              future: futurePatientIdList,
              builder: (context, patientIds) => ListView.builder(
                  itemCount: patientIds.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                          leading: const Icon(ManvIcons.patient),
                          title: Text(AppLocalizations.of(context)!
                              .patientScreenName(patientIds[index])),
                          onTap: () => PatientService.goToPatientScreen(
                              patientIds[index], context))))),
        ));
  }
}
