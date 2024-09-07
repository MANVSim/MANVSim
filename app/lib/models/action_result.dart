import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';

import 'conditions.dart';

class ActionResult {

  final Patient patient;
  final Conditions conditions;
  final PatientAction action;

  ActionResult({required this.patient, required this.conditions, required this.action});

  factory ActionResult.fromApi(RunActionPerformResultGet200Response response, PatientAction sourceAction) {
    return ActionResult(
        action: sourceAction,
        patient: Patient.fromApi(response.patient),
        conditions: ConditionsExtension.fromApi(response.conditions)
    );
  }
}