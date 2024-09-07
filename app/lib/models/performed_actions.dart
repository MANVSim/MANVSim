import 'package:manv_api/api.dart';
import 'package:manvsim/models/patient_action.dart';
import 'package:manvsim/models/resource.dart';

class PerformedAction {
  final PatientAction action;
  final String id;
  final String playerTan;
  final List<Resource> resources;
  final DateTime startTime;

  PerformedAction(
      {required this.action,
      required this.id,
      required this.playerTan,
      required this.resources,
      required this.startTime});
  
  factory PerformedAction.fromApi(PerformedActionDTO dto) {
    return PerformedAction(
        action: PatientAction.fromApi(dto.action),
        id: dto.id,
        playerTan: dto.playerTan,
        resources: dto.resourcesUsed.map(Resource.fromApi).toList(),
        startTime: DateTime.fromMillisecondsSinceEpoch(dto.time));
  }
}

typedef PerformedActions = List<PerformedAction>;

extension PerformedActionsExtension on PerformedActions {
  static PerformedActions fromApi(List<PerformedActionDTO> dtos) {
    return dtos.map(PerformedAction.fromApi).toList();
  }
}