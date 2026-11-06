import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/estadisticas.dart';

class ApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbwLFnqQXum088C7z06flSaezFG7QL0uKRoJq285FT36VXdRJ7pRghXMc9jQHoPq_GqdkQ/exec';

  static Future<int> obtenerRegistrados() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error HTTP ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Error al consultar la API',
      );
    }

    return data['registrados'] ?? 0;
  }

  static Future<Estadisticas> obtenerEstadisticas() async {
    final response = await http
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final Map<String, dynamic> data =
    jsonDecode(response.body);

    if (data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Error al consultar estadísticas',
      );
    }

    return Estadisticas.fromJson(data);
  }
}