import 'package:manv_api/api.dart';

class PlayerPerson {
  String name;
  String role;
  String tan;

  PlayerPerson({required this.name, required this.role, required this.tan});

  factory PlayerPerson.fromApi(RunLocationPersonsGet200ResponsePlayersInner dto) {
    return PlayerPerson(
      name: dto.name??'',
      role: dto.role!,
      tan: dto.tan!,
    );
  }
}

class PatientPerson {

  String name;
  int id;

  PatientPerson({required this.name, required this.id});

  factory PatientPerson.fromApi(RunLocationPersonsGet200ResponsePatientsInner dto) {
    return PatientPerson(
      name: dto.name!,
      id: dto.id!,
    );
  }
}

typedef PlayerPersons = List<PlayerPerson>;
typedef PatientPersons = List<PatientPerson>;

class Persons {
  final PlayerPersons players;
  final PatientPersons patients;

  Persons({required this.players, required this.patients});

  factory Persons.fromApi(RunLocationPersonsGet200Response dto) {
    return Persons(
      players: dto.players.map(PlayerPerson.fromApi).toList(),
      patients: dto.patients.map(PatientPerson.fromApi).toList(),
    );
  }
}
