import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/models/performed_actions.dart';

class Patient {
  final int id;
  final String name;
  final Location location;
  final MultiMediaCollection media;
  final PerformedActions performedActions;

  Patient(
      {required this.id,
      required this.name,
      required this.location,
      required this.media,
      required this.performedActions});

  PerformedAction getPerformedActionById(String id) {
    return performedActions.firstWhere((element) => element.id == id);
  }

  factory Patient.fromApi(PatientDTO dto) {
    return Patient(
        id: dto.id,
        name: dto.name,
        location: Location.fromApi(dto.location),
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences),
        performedActions:
            PerformedActionsExtension.fromApi(dto.performedActions));
  }
}
