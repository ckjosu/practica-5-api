import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const UbicacionPage(),
    ));

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});
  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  Position? posicion;
  String mensaje = 'Sin ubicación';

  Future<void> obtener() async {
    setState(() => mensaje = 'Buscando ubicación...');
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => mensaje = 'Activa el servicio de ubicación');
        return;
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        setState(() => mensaje = 'Permiso de ubicación no disponible');
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      setState(() {
        posicion = p;
        mensaje = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() => mensaje = 'Error al obtener ubicación: $e');
    }
  }

  Future<void> abrirMapa() async {
    if (posicion == null) {
      setState(() => mensaje = 'Primero obtén la ubicación');
      return;
    }
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${posicion!.latitude},${posicion!.longitude}');
    try {
      var ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!ok) setState(() => mensaje = 'No se pudo abrir el mapa');
    } catch (e) {
      setState(() => mensaje = 'Error al abrir el mapa: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mi ubicación')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 80),
                Text(mensaje, textAlign: TextAlign.center),
                if (posicion != null) ...[
                  Text('Latitud: ${posicion!.latitude}'),
                  Text('Longitud: ${posicion!.longitude}'),
                  Text('Precisión: ${posicion!.accuracy} m'),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: obtener,
                  child: const Text('Obtener ubicación'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: abrirMapa,
                  child: const Text('Abrir en mapa'),
                ),
              ],
            ),
          ),
        ),
      );
}
