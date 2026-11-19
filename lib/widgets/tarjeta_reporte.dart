import 'dart:io';
import 'package:flutter/material.dart';
import '../models/reporte.dart';

class TarjetaReporte extends StatelessWidget {
  final Reporte reporte;
  final VoidCallback onTap;
  const TarjetaReporte({super.key, required this.reporte, required this.onTap});

  
  @override

  
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: reporte.rutaFoto == null
              ? const CircleAvatar(child: Icon(Icons.report))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(reporte.rutaFoto!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                ),
          title: Text(reporte.titulo),
          subtitle: Text('${reporte.categoria} · ${reporte.fechaTexto}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}
