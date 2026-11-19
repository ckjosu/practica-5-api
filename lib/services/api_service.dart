import 'dart:convert';
import 'package:http/http.dart' as http;

class Aviso {
  final int id;
  final String titulo;
  final String cuerpo;
  const Aviso({required this.id, required this.titulo, required this.cuerpo});

  factory Aviso.fromJson(Map<String, dynamic> j) => Aviso(
        id: j['id'] as int,
        titulo: j['title'] as String,
        cuerpo: j['body'] as String,
      );
}

class ApiService {
  static final _url =
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10');

  static Future<List<Aviso>> avisos() async {
    final r = await http.get(_url).timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) {
      throw Exception('El servidor respondió ${r.statusCode}');
    }
    final datos = jsonDecode(r.body) as List<dynamic>;
    return datos.map((e) => Aviso.fromJson(e as Map<String, dynamic>)).toList();
  }
}
