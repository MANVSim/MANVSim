import 'package:manv_api/api.dart';

class PatientAction {
  final int id;
  final String name;
  final int durationInSeconds;
  final List<String> resourceNamesNeeded;

  PatientAction(
      {required this.id,
      required this.name,
      required this.durationInSeconds,
      required this.resourceNamesNeeded});

  factory PatientAction.fromApi(ActionDTO dto) {
    return PatientAction(
        id: dto.id,
        name: dto.name,
        durationInSeconds: dto.durationSec,
        resourceNamesNeeded: dto.resourcesNeeded,
    );
  }
}
