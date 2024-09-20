import 'package:flutter/material.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/models/performed_actions.dart';

enum PatientClass {
  notClassified('NOT_CLASSIFIED'),
  preRed('PRE_RED'),
  red('RED'),
  preYellow('PRE_YELLOW'),
  yellow('YELLOW'),
  preGreen('PRE_GREEN'),
  green('GREEN'),
  preBlue('PRE_BLUE'),
  blue('BLUE'),
  black('BLACK');

  final String value;
  const PatientClass(this.value);

  bool get isPre => switch (this) {
        PatientClass.preRed ||
        PatientClass.preYellow ||
        PatientClass.preGreen ||
        PatientClass.preBlue =>
          true,
        _ => false
      };

  /// Returns the corresponding color to a classification.
  Color get color => switch (this) {
        PatientClass.preRed || PatientClass.red => Colors.red.shade700,
        PatientClass.preYellow || PatientClass.yellow => Colors.yellow.shade600,
        PatientClass.preGreen || PatientClass.green => Colors.green.shade700,
        PatientClass.preBlue || PatientClass.blue => Colors.blue.shade700,
        PatientClass.black => Colors.black,
        _ => Colors.grey.shade600,
      };

  factory PatientClass.fromString(String classification) {
    return PatientClass.values.firstWhere(
        (patientClass) => patientClass.value == classification,
        orElse: () =>
            throw Exception('Unknown classification: $classification'));
  }
}

class Patient {
  final int id;
  final String name;
  final Location location;
  final MultiMediaCollection media;
  final PerformedActions performedActions;
  final PatientClass classification;

  Patient(
      {required this.id,
      required this.name,
      required this.location,
      required this.media,
      required this.performedActions,
      required this.classification});

  PerformedAction getPerformedActionById(String id) {
    return performedActions.firstWhere((element) => element.id == id);
  }

  factory Patient.fromApi(PatientDTO dto) {
    return Patient(
        id: dto.id,
        name: dto.name,
        classification: PatientClass.fromString(dto.classification.value),
        location: Location.fromApi(dto.location),
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences),
        performedActions:
            PerformedActionsExtension.fromApi(dto.performedActions));
  }
}
