import 'package:flutter/material.dart';

import 'database/db.dart';
import 'preferencias.dart';

class PantallaNotas extends StatefulWidget {
  const PantallaNotas({super.key});

  @override
  State<PantallaNotas> createState() => _PantallaNotasState();
}

class _PantallaNotasState extends State<PantallaNotas> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _contenidoCtrl = TextEditingController();
  List<Map<String, dynamic>> _notas = [];
  int? _idEditando;
  String _nombre = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _contenidoCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final nombre = await leerNombre();
    final notas = await DB.listar();
    if (!mounted) return;
    setState(() {
      _nombre = nombre;
      _notas = notas;
    });
  }

  void _limpiar() {
    _tituloCtrl.clear();
    _contenidoCtrl.clear();
    _idEditando = null;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();
    if (_idEditando == null) {
      await DB.insertar(titulo, contenido);
    } else {
      await DB.actualizar(_idEditando!, titulo, contenido);
    }
    setState(_limpiar);
    await _cargar();
  }

  void _editar(Map<String, dynamic> nota) {
    setState(() {
      _idEditando = nota['id'] as int;
      _tituloCtrl.text = (nota['titulo'] ?? '') as String;
      _contenidoCtrl.text = (nota['contenido'] ?? '') as String;
    });
  }

  Future<void> _eliminar(Map<String, dynamic> nota) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Eliminar "${nota['titulo']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DB.eliminar(nota['id'] as int);
      if (_idEditando == nota['id']) setState(_limpiar);
      await _cargar();
    }
  }

  Future<void> _cambiarNombre() async {
    final ctrl = TextEditingController(
      text: _nombre == 'Invitado' ? '' : _nombre,
    );
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevo != null && nuevo.isNotEmpty) {
      await guardarNombre(nuevo);
      if (!mounted) return;
      setState(() => _nombre = nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombre'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: _cambiarNombre),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'El título es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contenidoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _guardar,
                          child: Text(
                            _idEditando == null ? 'Guardar' : 'Actualizar',
                          ),
                        ),
                      ),
                      if (_idEditando != null) ...[
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(_limpiar),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _notas.isEmpty
                ? const Center(child: Text('No hay notas'))
                : ListView.builder(
                    itemCount: _notas.length,
                    itemBuilder: (context, i) {
                      final n = _notas[i];
                      return ListTile(
                        title: Text((n['titulo'] ?? '') as String),
                        subtitle: Text((n['contenido'] ?? '') as String),
                        onTap: () => _editar(n),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminar(n),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
