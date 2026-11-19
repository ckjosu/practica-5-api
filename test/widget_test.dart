import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/registro.dart';

void main() {
  final registro = Registro(
    rutaFoto: 'foto.jpg',
    fecha: DateTime(2026, 11, 18, 18, 30, 5),
    acelerometro: [1, 2, 3],
    giroscopio: [0.5, 0, -1],
  );

  test('formatea la fecha y la hora', () {
    expect(registro.fechaTexto, '18/11/2026 18:30:05');
  });

  test('formatea un vector con dos decimales', () {
    expect(Registro.vector(registro.acelerometro), 'X: 1.00  Y: 2.00  Z: 3.00');
  });

  test('guarda los valores de los sensores', () {
    expect(registro.giroscopio, [0.5, 0, -1]);
  });
}
