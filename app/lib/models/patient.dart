class Patient {
  final int id;
  String description;

  Patient({
    required this.id,
    required this.description
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'description': String description} =>
          Patient(id: id, description: description),
      _ => throw const FormatException('Failed to parse patient from JSON.')
    };
  }
}