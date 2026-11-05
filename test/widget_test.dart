import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/preferencias.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('el nombre por defecto es Invitado', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await leerNombre(), 'Invitado');
  });

  test('guarda y lee el nombre', () async {
    SharedPreferences.setMockInitialValues({});
    await guardarNombre('Josue');
    expect(await leerNombre(), 'Josue');
  });
}
