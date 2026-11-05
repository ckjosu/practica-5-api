import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre_usuario', nombre);
  }

  static Future<String> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nombre_usuario') ?? 'Invitado';
  }

  static Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filtro_tareas', filtro);
  }

  static Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('filtro_tareas') ?? 'todas';
  }
}
