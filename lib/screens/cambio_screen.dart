import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CambioScreen extends StatefulWidget {
  const CambioScreen({super.key});
 
  State<CambioScreen> createState() => _CambioScreenState();
}

class _CambioScreenState extends State<CambioScreen> {
  late Future<double> _futuro = ApiService.dolarEnPesos();

  void _reintentar() => setState(() => _futuro = ApiService.dolarEnPesos());

 
  Widget build(BuildContext context) => FutureBuilder<double>(
        future: _futuro,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 56),
                  const SizedBox(height: 8),
                  const Text('No se pudo obtener el tipo de cambio.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _reintentar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.currency_exchange, size: 56),
                const SizedBox(height: 12),
                const Text('1 USD ='),
                Text(
                  '\$${s.data!.toStringAsFixed(2)} MXN',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      );
}
