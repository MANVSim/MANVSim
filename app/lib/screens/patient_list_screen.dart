import 'package:flutter/material.dart';

import 'package:manvsim/screens/base_list_screen.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/constants/manv_icons.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientListScreen extends StatelessWidget {

  const PatientListScreen({super.key});

  Future<BaseListScreenItems> fetchFutureItemList() {
    return PatientService.fetchPatientsIDs()
        .then((response) =>
        response.map((patient) => BaseListScreenItem(patient.name, patient.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return BaseListScreen(
        title: AppLocalizations.of(context)!.patientListScreenName,
        icon: ManvIcons.patient,
        nameFromId: AppLocalizations.of(context)!.patientNameFromId,
        fetchFutureItemList: fetchFutureItemList,
        onItemTap: (context, item) => PatientService.goToPatientScreen(item.id, context));
  }

}
