import 'package:manv_api/api.dart';

class Patient {
  final int id;
  final String name;
  final String injuries;

  Patient({required this.id, required this.name, required this.injuries});

  factory Patient.fromApi(PatientDTO dto) {
    return Patient.fromJson(dto.toJson());
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'name': String name, 'injuries': String injuries} =>
        Patient(id: id, name: name, injuries: injuries),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }
}
