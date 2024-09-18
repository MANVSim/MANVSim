//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;


class PatientClassification {
  /// Instantiate a new enum with the provided [value].
  const PatientClassification._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const NOT_CLASSIFIED = PatientClassification._(r'NOT_CLASSIFIED');
  static const PRE_RED = PatientClassification._(r'PRE_RED');
  static const RED = PatientClassification._(r'RED');
  static const PRE_YELLOW = PatientClassification._(r'PRE_YELLOW');
  static const YELLOW = PatientClassification._(r'YELLOW');
  static const PRE_GREEN = PatientClassification._(r'PRE_GREEN');
  static const GREEN = PatientClassification._(r'GREEN');
  static const PRE_BLUE = PatientClassification._(r'PRE_BLUE');
  static const BLUE = PatientClassification._(r'BLUE');
  static const BLACK = PatientClassification._(r'BLACK');

  /// List of all possible values in this [enum][PatientClassification].
  static const values = <PatientClassification>[
    NOT_CLASSIFIED,
    PRE_RED,
    RED,
    PRE_YELLOW,
    YELLOW,
    PRE_GREEN,
    GREEN,
    PRE_BLUE,
    BLUE,
    BLACK,
  ];

  static PatientClassification? fromJson(dynamic value) => PatientClassificationTypeTransformer().decode(value);

  static List<PatientClassification> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PatientClassification>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PatientClassification.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PatientClassification] to String,
/// and [decode] dynamic data back to [PatientClassification].
class PatientClassificationTypeTransformer {
  factory PatientClassificationTypeTransformer() => _instance ??= const PatientClassificationTypeTransformer._();

  const PatientClassificationTypeTransformer._();

  String encode(PatientClassification data) => data.value;

  /// Decodes a [dynamic value][data] to a PatientClassification.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PatientClassification? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'NOT_CLASSIFIED': return PatientClassification.NOT_CLASSIFIED;
        case r'PRE_RED': return PatientClassification.PRE_RED;
        case r'RED': return PatientClassification.RED;
        case r'PRE_YELLOW': return PatientClassification.PRE_YELLOW;
        case r'YELLOW': return PatientClassification.YELLOW;
        case r'PRE_GREEN': return PatientClassification.PRE_GREEN;
        case r'GREEN': return PatientClassification.GREEN;
        case r'PRE_BLUE': return PatientClassification.PRE_BLUE;
        case r'BLUE': return PatientClassification.BLUE;
        case r'BLACK': return PatientClassification.BLACK;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PatientClassificationTypeTransformer] instance.
  static PatientClassificationTypeTransformer? _instance;
}

