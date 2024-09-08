import 'package:manv_api/api.dart';
import 'package:manvsim/models/multi_media.dart';

class Condition {
  final String name;
  final MultiMediaCollection media;

  Condition({required this.name, required this.media});

  factory Condition.fromApi(
      MapEntry<String, List<MediaReferencesDTOInner>> entry) {
    return Condition(
        name: entry.key,
        media: MultiMediaCollectionExtension.fromApi(entry.value));
  }
}

typedef Conditions = List<Condition>;

extension ConditionsExtension on Conditions {
  static Conditions fromApi(
      Map<String, List<MediaReferencesDTOInner>> conditions) {
    return conditions.entries.map((entry) => Condition.fromApi(entry)).toList();
  }
}
