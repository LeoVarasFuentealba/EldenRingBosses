class Boss {
  final String name;
  final String description;
  final String imageUrl;
  double rating; // Nueva propiedad para la calificación

  Boss({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0, // Valor predeterminado de la calificación
  });

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      imageUrl: json['image'] ?? '',
    );
  }
}
