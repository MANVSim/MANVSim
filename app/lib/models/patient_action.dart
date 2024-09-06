import 'package:manv_api/api.dart';
import 'package:manvsim/models/multi_media.dart';

class PatientAction {
  final int id;
  final String name;
  final int durationInSeconds;
  final List<String> resourceNamesNeeded;
  final MultiMediaCollection media;

  PatientAction(
      {required this.id,
      required this.name,
      required this.durationInSeconds,
      required this.resourceNamesNeeded,
      required this.media});

  factory PatientAction.fromApi(ActionDTO dto) {
    return PatientAction(
        id: dto.id,
        name: dto.name,
        durationInSeconds: dto.durationSec,
        resourceNamesNeeded: dto.resourcesNeeded,
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences));
  }
}
