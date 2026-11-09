import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/providers/contador_provider.dart';

void main() {
  test('el contador inicia en 0', () {
    expect(ContadorProvider().valor, 0);
  });

  test('incrementar suma 1', () {
    final contador = ContadorProvider();
    contador.incrementar();
    expect(contador.valor, 1);
  });
}
