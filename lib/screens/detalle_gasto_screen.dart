import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../services/db_service.dart';

class DetalleGastoScreen extends StatelessWidget {
  final Gasto gasto;
  const DetalleGastoScreen({super.key, required this.gasto});

  Future<void> _borrar(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: const Text('¿Seguro que quieres eliminarlo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    await DbService.eliminar(gasto.id!);
    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalle'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _borrar(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gasto.concepto,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('\$${gasto.monto.toStringAsFixed(2)} MXN',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Chip(label: Text(gasto.categoria)),
              const SizedBox(height: 8),
              Text('Fecha: ${gasto.fechaTexto}'),
              const SizedBox(height: 8),
              Text(gasto.latitud == null
                  ? 'Sin ubicación'
                  : 'Ubicación: ${gasto.latitud!.toStringAsFixed(5)}, '
                      '${gasto.longitud!.toStringAsFixed(5)}'),
            ],
          ),
        ),
      );
}
