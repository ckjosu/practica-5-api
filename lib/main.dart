import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'registro.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bitácora de inspección',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const BitacoraPage(),
  ),
);

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});
  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final List<Registro> _registros = [];
  List<double> _acel = [0, 0, 0];
  List<double> _giro = [0, 0, 0];
  String _mensaje = '';
  StreamSubscription<AccelerometerEvent>? _acelSub;
  StreamSubscription<GyroscopeEvent>? _giroSub;

  @override
  void initState() {
    super.initState();
    _acelSub = accelerometerEventStream().listen(
      (e) {
        if (mounted) setState(() => _acel = [e.x, e.y, e.z]);
      },
      onError: (_) {
        if (mounted) setState(() => _mensaje = 'Acelerómetro no disponible');
      },
    );
    _giroSub = gyroscopeEventStream().listen(
      (e) {
        if (mounted) setState(() => _giro = [e.x, e.y, e.z]);
      },
      onError: (_) {
        if (mounted) setState(() => _mensaje = 'Giroscopio no disponible');
      },
    );
  }

  @override
  void dispose() {
    _acelSub?.cancel();
    _giroSub?.cancel();
    super.dispose();
  }

  Future<void> _nuevaInspeccion() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (f == null) {
        setState(() => _mensaje = 'Captura cancelada');
        return;
      }
      setState(() {
        _registros.insert(
          0,
          Registro(
            rutaFoto: f.path,
            fecha: DateTime.now(),
            acelerometro: List.of(_acel),
            giroscopio: List.of(_giro),
          ),
        );
        _mensaje = 'Inspección registrada';
      });
    } on PlatformException catch (e) {
      setState(
        () => _mensaje = e.code == 'camera_access_denied'
            ? 'Permiso de cámara denegado. Actívalo en Ajustes del dispositivo.'
            : 'Error de cámara: ${e.message ?? e.code}',
      );
    } catch (e) {
      setState(() => _mensaje = 'No se pudo usar la cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bitácora de inspección')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lecturas en vivo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Acelerómetro  ${Registro.vector(_acel)}'),
                Text('Giroscopio  ${Registro.vector(_giro)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _nuevaInspeccion,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Nueva inspección'),
        ),
        if (_mensaje.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_mensaje),
          ),
        const SizedBox(height: 16),
        if (_registros.isEmpty)
          const Center(child: Text('Aún no hay inspecciones registradas')),
        for (final r in _registros) _TarjetaEvidencia(registro: r),
      ],
    ),
  );
}

class _TarjetaEvidencia extends StatelessWidget {
  final Registro registro;
  const _TarjetaEvidencia({required this.registro});

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.file(
          File(registro.rutaFoto),
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha y hora: ${registro.fechaTexto}'),
              const SizedBox(height: 4),
              Text('Acelerómetro  ${Registro.vector(registro.acelerometro)}'),
              Text('Giroscopio  ${Registro.vector(registro.giroscopio)}'),
            ],
          ),
        ),
      ],
    ),
  );
}
