import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/reporte.dart';
import '../services/db_service.dart';
import '../services/notificaciones.dart';
import '../services/ubicacion_service.dart';

class NuevoReporteScreen extends StatefulWidget {
  const NuevoReporteScreen({super.key});
  @override
  State<NuevoReporteScreen> createState() => _NuevoReporteScreenState();
}

class _NuevoReporteScreenState extends State<NuevoReporteScreen> {
  static const _categorias = [
    'Infraestructura',
    'Seguridad',
    'Limpieza',
    'Otro',
  ];
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _categoria = _categorias.first;
  String? _rutaFoto;
  double? _lat;
  double? _lon;
  String _mensaje = '';
  bool _guardando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    try {
      final f = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 75);
      if (f == null) {
        setState(() => _mensaje = 'Captura cancelada');
        return;
      }
      setState(() {
        _rutaFoto = f.path;
        _mensaje = '';
      });
    } on PlatformException catch (e) {
      setState(() => _mensaje = e.code == 'camera_access_denied'
          ? 'Permiso de cámara denegado'
          : 'Error de cámara: ${e.message ?? e.code}');
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _mensaje = 'Buscando ubicación...');
    try {
      final p = await UbicacionService.obtener();
      setState(() {
        _lat = p.latitude;
        _lon = p.longitude;
        _mensaje = 'Ubicación obtenida';
      });
    } on UbicacionException catch (e) {
      setState(() => _mensaje = e.mensaje);
    } catch (_) {
      setState(() => _mensaje = 'No se pudo obtener la ubicación');
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await DbService.insertar(Reporte(
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descCtrl.text.trim(),
        categoria: _categoria,
        rutaFoto: _rutaFoto,
        latitud: _lat,
        longitud: _lon,
        fecha: DateTime.now(),
      ));
      try {
        await Notificaciones.mostrar('Reporte guardado', _tituloCtrl.text.trim());
      } catch (_) {}
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _guardando = false;
          _mensaje = 'No se pudo guardar: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nuevo reporte')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'El título es obligatorio';
                  if (t.length < 3) return 'Mínimo 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'La descripción es obligatoria';
                  if (t.length < 10) return 'Mínimo 10 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: [
                  for (final c in _categorias)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setState(() => _categoria = v ?? _categoria),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _tomarFoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Foto'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _obtenerUbicacion,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Ubicación'),
                    ),
                  ),
                ],
              ),
              if (_rutaFoto != null) ...[
                const SizedBox(height: 12),
                Image.file(File(_rutaFoto!), height: 180, fit: BoxFit.cover),
              ],
              if (_lat != null) Text('Latitud: $_lat\nLongitud: $_lon'),
              const SizedBox(height: 8),
              const Text('La fecha y hora se registran al guardar.'),
              if (_mensaje.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_mensaje),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: Text(_guardando ? 'Guardando...' : 'Guardar reporte'),
              ),
            ],
          ),
        ),
      );
}
