import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const SensoresPage(),
  ),
);

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});
  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  XFile? foto;
  String mensaje = '';
  double x = 0, y = 0, z = 0;
  double gx = 0, gy = 0, gz = 0;
  StreamSubscription<AccelerometerEvent>? _acelSub;
  StreamSubscription<GyroscopeEvent>? _giroSub;

  @override
  void initState() {
    super.initState();
    _acelSub = accelerometerEventStream().listen(
      (e) {
        if (mounted) {
          setState(() {
            x = e.x;
            y = e.y;
            z = e.z;
          });
        }
      },
      onError: (_) {
        if (mounted) setState(() => mensaje = 'Acelerómetro no disponible');
      },
    );
    _giroSub = gyroscopeEventStream().listen(
      (e) {
        if (mounted) {
          setState(() {
            gx = e.x;
            gy = e.y;
            gz = e.z;
          });
        }
      },
      onError: (_) {
        if (mounted) setState(() => mensaje = 'Giroscopio no disponible');
      },
    );
  }

  @override
  void dispose() {
    _acelSub?.cancel();
    _giroSub?.cancel();
    super.dispose();
  }

  Future<void> tomarFoto() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (f == null) {
        setState(() => mensaje = 'Captura cancelada');
        return;
      }
      setState(() {
        foto = f;
        mensaje = 'Fotografía tomada';
      });
    } catch (e) {
      setState(() => mensaje = 'No se pudo usar la cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cámara y sensores')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FilledButton.icon(
          onPressed: tomarFoto,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar fotografía'),
        ),
        if (mensaje.isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(mensaje)),
        const SizedBox(height: 12),
        if (foto != null) Image.file(File(foto!.path), height: 250),
        const Divider(),
        Text('Acelerómetro X: ${x.toStringAsFixed(2)}'),
        Text('Acelerómetro Y: ${y.toStringAsFixed(2)}'),
        Text('Acelerómetro Z: ${z.toStringAsFixed(2)}'),
        const Divider(),
        Text('Giroscopio X: ${gx.toStringAsFixed(2)}'),
        Text('Giroscopio Y: ${gy.toStringAsFixed(2)}'),
        Text('Giroscopio Z: ${gz.toStringAsFixed(2)}'),
      ],
    ),
  );
}
