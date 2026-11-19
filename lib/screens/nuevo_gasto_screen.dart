import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../services/db_service.dart';
import '../services/notificaciones.dart';
import '../services/ubicacion_service.dart';

class NuevoGastoScreen extends StatefulWidget {
  const NuevoGastoScreen({super.key});
  
  @override
  
  State<NuevoGastoScreen> createState() => _NuevoGastoScreenState();
}

class _NuevoGastoScreenState extends State<NuevoGastoScreen> {
  final _form = GlobalKey<FormState>();
  final _concepto = TextEditingController();
  final _monto = TextEditingController();
  String _categoria = 'Comida';
  double? _lat;
  double? _lon;
  String? _mensaje;
  bool _guardando = false;

 
  @override

 
  void dispose() {
    _concepto.dispose();
    _monto.dispose();
    super.dispose();
  }

  Future<void> _ubicar() async {
    setState(() => _mensaje = 'Buscando ubicación...');
    try {
      final p = await UbicacionService.obtener();
      if (!mounted) return;
      setState(() {
        _lat = p.latitude;
        _lon = p.longitude;
        _mensaje = 'Ubicación guardada';
      });
    } on UbicacionException catch (e) {
      if (mounted) setState(() => _mensaje = e.mensaje);
    } catch (_) {
      if (mounted) setState(() => _mensaje = 'No se pudo obtener la ubicación');
    }
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final monto = double.parse(_monto.text.trim().replaceAll(',', '.'));
    try {
      await DbService.insertar(Gasto(
        concepto: _concepto.text.trim(),
        monto: monto,
        categoria: _categoria,
        latitud: _lat,
        longitud: _lon,
        fecha: DateTime.now(),
      ));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _mensaje = 'No se pudo guardar el gasto';
      });
      return;
    }
    try {
      await Notificaciones.mostrar(
          'Gasto registrado', '${_concepto.text.trim()}: \$$monto');
    } catch (_) {}
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nuevo gasto')),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _concepto,
                decoration: const InputDecoration(
                    labelText: 'Concepto', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().length < 3)
                    ? 'Mínimo 3 caracteres'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _monto,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    labelText: 'Monto (MXN)', border: OutlineInputBorder()),
                validator: (v) {
                  final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Escribe un monto mayor a 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                    labelText: 'Categoría', border: OutlineInputBorder()),
                items: const ['Comida', 'Transporte', 'Escuela', 'Ocio', 'Otro']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoria = v!),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _ubicar,
                icon: const Icon(Icons.my_location),
                label: const Text('Agregar ubicación'),
              ),
              if (_mensaje != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_mensaje!),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : 'Guardar'),
              ),
            ],
          ),
        ),
      );
}
