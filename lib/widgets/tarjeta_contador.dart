import 'package:flutter/material.dart';

class TarjetaContador extends StatelessWidget {
  final int valor;
  const TarjetaContador({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text('$valor', style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}
