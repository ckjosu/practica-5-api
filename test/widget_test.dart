import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/models/gasto.dart';

void main() {
  test('Gasto se convierte a mapa y de regreso', () {
    final g = Gasto(
      id: 1,
      concepto: 'Tacos',
      monto: 85.5,
      categoria: 'Comida',
      fecha: DateTime(2026, 11, 18, 19, 30),
    );
    final copia = Gasto.fromMap(g.toMap());
    expect(copia.concepto, 'Tacos');
    expect(copia.monto, 85.5);
    expect(copia.categoria, 'Comida');
    expect(copia.latitud, isNull);
  });
}
