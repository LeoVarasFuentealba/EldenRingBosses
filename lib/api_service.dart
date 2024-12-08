import 'dart:convert'; // Para decodificar respuestas JSON.
import 'package:http/http.dart' as http; // Cliente HTTP para realizar solicitudes.
import 'boss_model.dart'; // Modelo Boss.

class ApiService {
  final String baseUrl = 'https://eldenring.fanapis.com/api'; // URL base de la API.

  // Método para obtener la lista de bosses desde la API.
  Future<List<Boss>> fetchBosses() async {
    // Solicitud GET con un límite de 590 bosses.
    final response = await http.get(Uri.parse('$baseUrl/bosses?limit=20'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa (código 200).
      final data = jsonDecode(response.body)['data']; // Decodifica el JSON y extrae la lista de bosses.
      return List<Boss>.from(data.map((boss) => Boss.fromJson(boss))); // Convierte los datos a una lista de objetos Boss.
    } else {
      // Si ocurre un error, lanza una excepción.
      throw Exception('Failed to load bosses');
    }
  }
}
