import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../services/db_service.dart';
import 'detalle_gasto_screen.dart';
import 'lista_gastos.dart';

class GastosView extends StatefulWidget {
  const GastosView({super.key});
  @override
  State<GastosView> createState() => _GastosViewState();
}

class _GastosViewState extends State<GastosView> {
  late Future<List<Gasto>> _futuro = DbService.listar();

  void _recargar() => setState(() => _futuro = DbService.listar());

  Future<void> _abrir(Gasto g) async {
    final cambio = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetalleGastoScreen(gasto: g)),
    );
    if (cambio == true) _recargar();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Gasto>>(
        future: _futuro,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text('Error al cargar: ${s.error}'));
          }
          if (s.data!.isEmpty) {
            return const Center(child: Text('Aún no hay gastos'));
          }
          return ListaGastos(lista: s.data!, onTap: _abrir);
        },
      );
}
