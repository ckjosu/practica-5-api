import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AvisosView extends StatefulWidget {
  const AvisosView({super.key});
  @override
  State<AvisosView> createState() => _AvisosViewState();
}

class _AvisosViewState extends State<AvisosView> {
  late Future<List<Aviso>> _futuro = ApiService.avisos();

  void _reintentar() => setState(() => _futuro = ApiService.avisos());

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Aviso>>(
        future: _futuro,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 56),
                    const SizedBox(height: 8),
                    const Text('No se pudo cargar la información.'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _reintentar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final avisos = s.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: avisos.length,
            itemBuilder: (_, i) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${avisos[i].id}')),
                title: Text(avisos[i].titulo),
                subtitle: Text(
                  avisos[i].cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      );
}
