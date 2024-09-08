import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/performed_actions.dart';

import 'conditions.dart';

class ActionResult {
  final Patient patient;
  final Conditions conditions;
  final PerformedAction performedAction;

  ActionResult(
      {required this.patient,
      required this.conditions,
      required this.performedAction});

  factory ActionResult.fromApi(
      RunActionPerformResultGet200Response response, String resultId) {
    Patient patient = Patient.fromApi(response.patient);

    return ActionResult(
        performedAction: patient.getPerformedActionById(resultId),
        patient: patient,
        conditions: ConditionsExtension.fromApi(response.conditions));
  }
}
