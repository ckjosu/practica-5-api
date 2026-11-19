import 'package:geolocator/geolocator.dart';

class UbicacionException implements Exception {
  final String mensaje;
  const UbicacionException(this.mensaje);
  
  @override
  
  String toString() => mensaje;
}

class UbicacionService {
  static Future<Position> obtener() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const UbicacionException('Activa el servicio de ubicación');
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw const UbicacionException('Permiso de ubicación no disponible');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}
