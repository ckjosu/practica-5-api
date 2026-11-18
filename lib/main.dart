import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'punto.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Puntos de interés',
    theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
    home: const PuntosPage(),
  ),
);

class PuntosPage extends StatefulWidget {
  const PuntosPage({super.key});
  @override
  State<PuntosPage> createState() => _PuntosPageState();
}

class _PuntosPageState extends State<PuntosPage> {
  final _nombreCtrl = TextEditingController();
  final List<Punto> _puntos = [];
  Position? _actual;
  String _mensaje = 'Sin ubicación';
  bool _buscando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _aviso(String texto) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(texto)));

  Future<void> _obtener() async {
    setState(() {
      _buscando = true;
      _mensaje = 'Buscando ubicación...';
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _mensaje = 'Activa el servicio de ubicación');
        return;
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        setState(() => _mensaje = 'Permiso de ubicación no disponible');
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      setState(() {
        _actual = p;
        _mensaje = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() => _mensaje = 'Error al obtener ubicación: $e');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _guardar() {
    final nombre = _nombreCtrl.text.trim();
    final actual = _actual;
    if (actual == null) {
      _aviso('Primero obtén tu ubicación');
      return;
    }
    if (nombre.isEmpty) {
      _aviso('Escribe un nombre para el punto');
      return;
    }
    setState(() {
      _puntos.add(
        Punto(
          nombre: nombre,
          latitud: actual.latitude,
          longitud: actual.longitude,
        ),
      );
      _nombreCtrl.clear();
    });
  }

  Future<void> _abrirMapa(Punto p) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${p.latitud},${p.longitud}',
    );
    try {
      var ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!ok) _aviso('No se pudo abrir el mapa');
    } catch (e) {
      _aviso('Error al abrir el mapa: $e');
    }
  }

  String _distancia(Punto p) {
    final a = _actual;
    if (a == null) return 'Obtén tu ubicación para ver la distancia';
    return 'Distancia: ${Punto.formatear(p.distanciaDesde(a.latitude, a.longitude))}';
  }

  @override
  Widget build(BuildContext context) {
    final actual = _actual;
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de interés')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.my_location, size: 48),
                  Text(_mensaje, textAlign: TextAlign.center),
                  if (actual != null) ...[
                    Text('Latitud: ${actual.latitude}'),
                    Text('Longitud: ${actual.longitude}'),
                    Text('Precisión: ${actual.accuracy} m'),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _buscando ? null : _obtener,
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text('Obtener ubicación actual'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del punto',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: _guardar,
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Guardar punto'),
          ),
          const SizedBox(height: 16),
          Text(
            'Puntos guardados: ${_puntos.length} (mínimo 3)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (_puntos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Aún no hay puntos guardados'),
            ),
          for (var i = 0; i < _puntos.length; i++)
            Card(
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text(_puntos[i].nombre),
                subtitle: Text(
                  'Lat: ${_puntos[i].latitud.toStringAsFixed(6)}\n'
                  'Lon: ${_puntos[i].longitud.toStringAsFixed(6)}\n'
                  '${_distancia(_puntos[i])}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.map),
                      tooltip: 'Abrir en mapa',
                      onPressed: () => _abrirMapa(_puntos[i]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Eliminar',
                      onPressed: () => setState(() => _puntos.removeAt(i)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
