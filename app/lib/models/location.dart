import 'package:manvsim/models/patient_action.dart';

class Location {
  final int id;
  final String name;
  List<PatientAction> actions;
  List<Location> locations;

  Location(
      {required this.id,
      required this.name,
      required this.actions,
      required this.locations});

  factory Location.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'actions': List<dynamic> actions,
        'locations': List<dynamic> locations
      } =>
        Location(
            id: id,
            name: name,
            actions: actions
                .map((action) => PatientAction.fromJson(action))
                .toList(),
            locations: locations
                .map((location) => Location.fromJson(location))
                .toList()),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }
}
