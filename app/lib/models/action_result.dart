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

  factory ActionResult.fromPatient(
      Patient patient, String resultId) {

    PerformedAction performedAction = patient.getPerformedActionById(resultId);

    return ActionResult(
        performedAction: performedAction,
        patient: patient,
        conditions: performedAction.conditions);
  }
}
