import 'package:geolocator/geolocator.dart';

class Punto {
  final String nombre;
  final double latitud;
  final double longitud;

  const Punto({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  /// Distancia en metros desde la posición [lat], [lon].
  double distanciaDesde(double lat, double lon) =>
      Geolocator.distanceBetween(lat, lon, latitud, longitud);

  static String formatear(double metros) => metros < 1000
      ? '${metros.toStringAsFixed(0)} m'
      : '${(metros / 1000).toStringAsFixed(2)} km';
}
