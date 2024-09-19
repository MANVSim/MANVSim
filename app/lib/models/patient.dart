import 'package:flutter/material.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/models/performed_actions.dart';


enum PatientClass {
  notClassified,
  preRed,
  red,
  preYellow,
  yellow,
  preGreen,
  green,
  preBlue,
  blue,
  black,
}

extension PatientClassExtension on PatientClass {

  bool get isPre {
    switch (this) {
      case PatientClass.preRed:
      case PatientClass.preYellow:
      case PatientClass.preGreen:
      case PatientClass.preBlue:
        return true;
      default:
        return false;
    }
  }

  String get name {
    switch (this) {
      case PatientClass.notClassified:
        return 'NOT_CLASSIFIED';
      case PatientClass.preRed:
        return 'PRE_RED';
      case PatientClass.red:
        return 'RED';
      case PatientClass.preYellow:
        return 'PRE_YELLOW';
      case PatientClass.yellow:
        return 'YELLOW';
      case PatientClass.preGreen:
        return 'PRE_GREEN';
      case PatientClass.green:
        return 'GREEN';
      case PatientClass.preBlue:
        return 'PRE_BLUE';
      case PatientClass.blue:
        return 'BLUE';
      case PatientClass.black:
        return 'BLACK';
      default:
        return 'UNKNOWN';
    }
  }

  /// Gibt die entsprechende Farbe für die Klassifikation zurück.
  Color get color {
    switch (this) {
      case PatientClass.preRed:
      case PatientClass.red:
        return Colors.red;
      case PatientClass.preYellow:
      case PatientClass.yellow:
        return Colors.yellow;
      case PatientClass.preGreen:
      case PatientClass.green:
        return Colors.green;
      case PatientClass.preBlue:
      case PatientClass.blue:
        return Colors.blue;
      case PatientClass.black:
        return Colors.black;
      default:
        return Colors.grey;
    }
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


  static PatientClass _classificationFromString(String classification) {
    switch (classification) {
      case 'NOT_CLASSIFIED':
        return PatientClass.notClassified;
      case 'PRE_RED':
        return PatientClass.preRed;
      case 'RED':
        return PatientClass.red;
      case 'PRE_YELLOW':
        return PatientClass.preYellow;
      case 'YELLOW':
        return PatientClass.yellow;
      case 'PRE_GREEN':
        return PatientClass.preGreen;
      case 'GREEN':
        return PatientClass.green;
      case 'PRE_BLUE':
        return PatientClass.preBlue;
      case 'BLUE':
        return PatientClass.blue;
      case 'BLACK':
        return PatientClass.black;
      default:
        throw Exception('Unknown classification: $classification');
    }
  }



  factory Patient.fromApi(PatientDTO dto) {

    return Patient(
        id: dto.id,
        name: dto.name,
        classification: _classificationFromString(dto.classification.value),
        location: Location.fromApi(dto.location),
        media: MultiMediaCollectionExtension.fromApi(dto.mediaReferences),
        performedActions:
            PerformedActionsExtension.fromApi(dto.performedActions));
  }
}
