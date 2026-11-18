import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  test('distancia entre el mismo punto es 0', () {
    final d = Geolocator.distanceBetween(20.0, -90.0, 20.0, -90.0);
    expect(d, 0);
  });

  test('distancia entre dos puntos es mayor a 0', () {
    final d = Geolocator.distanceBetween(20.0, -90.0, 20.1, -90.0);
    expect(d, greaterThan(0));
  });
}
