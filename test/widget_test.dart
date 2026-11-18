import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/punto.dart';

void main() {
  const punto = Punto(nombre: 'Casa', latitud: 20.0, longitud: -90.0);

  test('la distancia al mismo punto es 0', () {
    expect(punto.distanciaDesde(20.0, -90.0), 0);
  });

  test('la distancia a otro punto es mayor a 0', () {
    expect(punto.distanciaDesde(20.1, -90.0), greaterThan(0));
  });

  test('formatea metros y kilómetros', () {
    expect(Punto.formatear(250), '250 m');
    expect(Punto.formatear(1500), '1.50 km');
  });
}
