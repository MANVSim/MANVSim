class PatientAction {
  final int id;
  final String name;
  final int durationInSeconds;
  final List<String> resourceNamesNeeded;

  PatientAction(
      {required this.id,
      required this.name,
      required this.durationInSeconds,
      required this.resourceNamesNeeded});

  factory PatientAction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'durationInSeconds': int durationInSeconds,
        'resourceNamesNeeded': List<dynamic> resourceNamesNeeded
      } =>
        PatientAction(
            id: id,
            name: name,
            durationInSeconds: durationInSeconds,
            resourceNamesNeeded: resourceNamesNeeded.cast()),
      _ =>
        throw const FormatException('Failed to parse patient action from JSON.')
    };
  }
}
