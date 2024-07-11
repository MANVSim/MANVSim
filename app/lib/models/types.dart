import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';

typedef PatientLocation = (Patient, Location);

typedef ConditionPatient = (Map<String, String>, Patient?);