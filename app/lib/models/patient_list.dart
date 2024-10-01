import 'package:manv_api/api.dart';

class PatientListEntry {
  final String name;
  final int id;

  PatientListEntry({required this.name, required this.id});
}

typedef PatientList = List<PatientListEntry>;

extension PatientListExtension on PatientList {
  static PatientList fromApi(RunPatientAllIdsGet200Response? dto) {
    if (dto == null) {
      return [];
    }

    List<int> patientIds = dto.patientIds;
    List<String> patientNames = dto.patientNames;

    assert (patientIds.length == patientNames.length);

    return List.generate(
        patientIds.length,
        (index) =>
            PatientListEntry(name: patientNames[index], id: patientIds[index]));
  }
}
