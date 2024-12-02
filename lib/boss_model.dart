// Modelo que representa un boss en el juego.
class Boss {
  final String name;
  final String description;
  final String imageUrl;
  double rating; // Calificación del boss (puede ser actualizada dinámicamente).

  // Constructor de la clase Boss.
  Boss({
    required this.name, // Nombre, Descripción y  URL obligatorios.
    required this.description,
    required this.imageUrl,
    this.rating = 0.0, // Valor predeterminado de la calificación.
  });

  // Fábrica que crea una instancia de Boss a partir de un JSON.
  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      name: json['name'] ?? 'Unknown', // Si no hay nombre, asigna "Unknown".
      description: json['description'] ?? 'No description available', // Descripción predeterminada si no está disponible.
      imageUrl: json['image'] ?? '', // Imagen vacía si no se proporciona.
    );
  }
}
