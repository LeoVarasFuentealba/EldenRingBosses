import 'dart:convert';
import 'package:http/http.dart' as http;
import 'boss_model.dart';

class ApiService {
  final String baseUrl = 'https://eldenring.fanapis.com/api';

  Future<List<Boss>> fetchBosses() async {
    final response = await http.get(Uri.parse('$baseUrl/bosses'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Boss>.from(data.map((boss) => Boss.fromJson(boss)));
    } else {
      throw Exception('Failed to load bosses');
    }
  }
}
