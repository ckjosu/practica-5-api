import 'dart:io';
import 'package:flutter/material.dart';
import '../models/reporte.dart';
import '../services/db_service.dart';

class DetalleScreen extends StatelessWidget {
  final Reporte reporte;
  const DetalleScreen({super.key, required this.reporte});

  Future<void> _eliminar(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reporte'),
        content: const Text('¿Seguro que quieres eliminarlo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DbService.eliminar(reporte.id!);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del reporte'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _eliminar(context),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (reporte.rutaFoto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(reporte.rutaFoto!),
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 240,
                    child: Center(child: Icon(Icons.broken_image, size: 64)),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(reporte.titulo,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Chip(label: Text(reporte.categoria)),
            Text('Fecha y hora: ${reporte.fechaTexto}'),
            const SizedBox(height: 12),
            Text(reporte.descripcion),
            const Divider(height: 32),
            Text(reporte.latitud == null
                ? 'Sin ubicación registrada'
                : 'Latitud: ${reporte.latitud}\nLongitud: ${reporte.longitud}'),
          ],
        ),
      );
}
