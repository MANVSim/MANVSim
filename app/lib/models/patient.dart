import 'package:manv_api/api.dart';

class Patient {
  final int id;
  final String name;
  final String injuries;

  Patient({required this.id, required this.name, required this.injuries});

  factory Patient.fromApi(PatientDTO dto) {
    if ([dto.id, dto.name, dto.injuries].contains(null)) {
      throw const FormatException('Failed to parse patient from JSON.');
    }
    return Patient(id: dto.id!, name: dto.name!, injuries: dto.injuries!);
  }
}
