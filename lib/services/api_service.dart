import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbw3uPWSIrl6cimlAv5NyTUB8INlJi0Nnlwj0g8S_GFpbX2qCEJ3O8MKojdHrkXXGtWpwQ/exec';

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
}