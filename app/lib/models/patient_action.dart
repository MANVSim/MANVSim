import 'package:manv_api/api.dart';
import 'package:manvsim/models/multi_media.dart';

class PatientAction {
  final int id;
  final String name;
  final Duration duration;
  final List<String> resourceNamesNeeded;
  final MultiMediaCollection media;
  final List<String> results;

  PatientAction(
      {required this.id,
      required this.name,
      required this.duration,
      required this.resourceNamesNeeded,
      required this.media,
      required this.results});

  factory PatientAction.fromApi(ActionDTO dto) {
    return PatientAction(
        id: dto.id,
        name: dto.name,
        duration: Duration(seconds: dto.durationSec),
        resourceNamesNeeded: dto.resourcesNeeded,
        results: dto.results,
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences));
  }
}
