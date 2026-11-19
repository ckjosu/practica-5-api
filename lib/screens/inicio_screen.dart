import 'package:flutter/material.dart';
import 'avisos_view.dart';
import 'nuevo_reporte_screen.dart';
import 'reportes_view.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});
  
  @override
  
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _tab = 0;
  int _version = 0;

  Future<void> _nuevo() async {
    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NuevoReporteScreen()),
    );
    if (creado == true) {
      setState(() {
        _version++;
        _tab = 0;
      });
    }
  }

  
  @override

  
  Widget build(BuildContext context) {
    final vistas = [
      ReportesView(key: ValueKey(_version)),
      const AvisosView(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Móvil de Incidencias'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: vistas[_tab],
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: _nuevo,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.list_alt), label: 'Reportes'),
          NavigationDestination(
              icon: Icon(Icons.campaign), label: 'Avisos'),
        ],
      ),
    );
  }
}
