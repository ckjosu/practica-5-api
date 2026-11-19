import 'package:flutter/material.dart';
import 'cambio_screen.dart';
import 'gastos_view.dart';
import 'nuevo_gasto_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});
  
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _tab = 0;
  int _version = 0;

  Future<void> _nuevo() async {
    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NuevoGastoScreen()),
    );
    if (creado == true) {
      setState(() {
        _version++;
        _tab = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Control de Gastos'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: _tab == 0 ? GastosView(key: ValueKey(_version)) : const CambioScreen(),
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
            NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Gastos'),
            NavigationDestination(icon: Icon(Icons.currency_exchange), label: 'Dólar'),
          ],
        ),
      );
}
