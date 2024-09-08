import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/multi_media.dart';

class Patient {
  final int id;
  final String name;
  final Location location;
  final MultiMediaCollection media;

  Patient(
      {required this.id,
      required this.name,
      required this.location,
      required this.media});

  factory Patient.fromApi(PatientDTO dto) {
    return Patient(
        id: dto.id,
        name: dto.name,
        location: Location.fromApi(dto.location),
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences));
  }
}
