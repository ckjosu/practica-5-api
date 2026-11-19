import 'package:flutter/material.dart';
import '../models/reporte.dart';
import '../services/db_service.dart';
import '../widgets/tarjeta_reporte.dart';
import 'detalle_screen.dart';

class ReportesView extends StatefulWidget {
  const ReportesView({super.key});
  
  @override
  
  State<ReportesView> createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  late Future<List<Reporte>> _futuro = DbService.listar();

  void _recargar() => setState(() => _futuro = DbService.listar());

  Future<void> _abrir(Reporte r) async {
    final cambio = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(reporte: r)),
    );
    if (cambio == true) _recargar();
  }

  
  @override

  
  Widget build(BuildContext context) => FutureBuilder<List<Reporte>>(
        future: _futuro,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text('Error al cargar: ${s.error}'));
          }
          final lista = s.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('Aún no hay reportes'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: lista.length,
            itemBuilder: (_, i) => TarjetaReporte(
              reporte: lista[i],
              onTap: () => _abrir(lista[i]),
            ),
          );
        },
      );
}
