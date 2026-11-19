import 'package:flutter/material.dart';
import '../models/gasto.dart';

class ListaGastos extends StatelessWidget {
  final List<Gasto> lista;
  final void Function(Gasto) onTap;
  const ListaGastos({super.key, required this.lista, required this.onTap});

 
  Widget build(BuildContext context) {
    final total = lista.fold<double>(0, (a, g) => a + g.monto);
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Total gastado'),
            trailing: Text('\$${total.toStringAsFixed(2)}'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: lista.length,
            itemBuilder: (_, i) => Card(
              child: ListTile(
                title: Text(lista[i].concepto),
                subtitle: Text('${lista[i].categoria} · ${lista[i].fechaTexto}'),
                trailing: Text('\$${lista[i].monto.toStringAsFixed(2)}'),
                onTap: () => onTap(lista[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
