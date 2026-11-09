import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/boton_accion.dart';
import '../widgets/encabezado.dart';
import '../widgets/tarjeta_contador.dart';

class PantallaContador extends StatelessWidget {
  const PantallaContador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Práctica 7: Arquitectura')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Encabezado(texto: 'Contador con Provider'),
            const SizedBox(height: 16),
            Consumer<ContadorProvider>(
              builder: (context, contador, _) =>
                  TarjetaContador(valor: contador.valor),
            ),
            const SizedBox(height: 16),
            BotonAccion(
              texto: 'Incrementar',
              onPressed: () => context.read<ContadorProvider>().incrementar(),
            ),
          ],
        ),
      ),
    );
  }
}
