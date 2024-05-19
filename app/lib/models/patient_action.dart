class PatientAction {
  final int id;
  String name;
  int durationInSeconds;

  PatientAction(
      {required this.id, required this.name, required this.durationInSeconds});

  factory PatientAction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'durationInSeconds': int durationInSeconds
      } =>
        PatientAction(
            id: id,
            name: name,
            durationInSeconds: durationInSeconds),
      _ =>
        throw const FormatException('Failed to parse patient action from JSON.')
    };
  }
}
