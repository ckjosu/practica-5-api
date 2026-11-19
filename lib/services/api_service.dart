import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<double> dolarEnPesos() async {
    final r = await http
        .get(Uri.parse('https://open.er-api.com/v6/latest/USD'))
        .timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) {
      throw Exception('Error del servidor (${r.statusCode})');
    }
    final datos = jsonDecode(r.body) as Map<String, dynamic>;
    return (datos['rates']['MXN'] as num).toDouble();
  }
}
