class Resource {
  final int id;
  final String name;
  int quantity;
  bool selected = false;

  Resource(
      {required this.id, required this.name, required this.quantity});

  factory Resource.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'quantity': int quantity
      } =>
          Resource(
              id: id,
              name: name,
              quantity: quantity),
      _ =>
      throw const FormatException('Failed to parse resource from JSON.')
    };
  }
}
