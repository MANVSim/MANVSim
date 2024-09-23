import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/person.dart';
import 'package:manvsim/services/patient_service.dart';

import '../../constants/manv_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPatientList extends StatelessWidget {
  final Persons persons;
  final String emptyText;

  const LocationPatientList(
      {required this.persons, required this.emptyText, super.key});

  Widget _buildPatient(PatientPerson patient, BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(children: [
              Row(
                children: [
                  const Icon(
                    ManvIcons.patient,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(
                    patient.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
                  ElevatedButton(
                      onPressed: () =>
                          PatientService.goToPatientScreen(patient.id, context),
                      child: Text(AppLocalizations.of(context)!
                          .locationScreenPatientListVisit)),
                ],
              ),
            ])));
  }

  Widget _buildEmpty(BuildContext context) {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(16), child: Text(emptyText))));
  }

  @override
  Widget build(BuildContext context) {
    if (persons.patients.isEmpty) {
      return _buildEmpty(context);
    } else {
      return Column(
        children: [
          for (var patient in persons.patients) _buildPatient(patient, context),
        ],
      );
    }
  }
}
