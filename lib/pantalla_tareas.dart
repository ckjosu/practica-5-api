import 'package:flutter/material.dart';

import 'database/tareas_db.dart';
import 'preferencias.dart';

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  List<Map<String, dynamic>> _tareas = [];
  int? _idEditando;
  String _nombre = 'Invitado';
  String _filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarTodo() async {
    final nombre = await Preferencias.leerNombre();
    final filtro = await Preferencias.leerFiltro();
    final tareas = await TareasDB.listar();
    if (!mounted) return;
    setState(() {
      _nombre = nombre;
      _filtro = filtro;
      _tareas = tareas;
    });
  }

  Future<void> _recargarTareas() async {
    final tareas = await TareasDB.listar();
    if (!mounted) return;
    setState(() => _tareas = tareas);
  }

  List<Map<String, dynamic>> get _tareasFiltradas {
    if (_filtro == 'pendientes') {
      return _tareas.where((t) => t['completada'] == 0).toList();
    }
    if (_filtro == 'completadas') {
      return _tareas.where((t) => t['completada'] == 1).toList();
    }
    return _tareas;
  }

  void _limpiarFormulario() {
    _tituloCtrl.clear();
    _descCtrl.clear();
    _idEditando = null;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final titulo = _tituloCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (_idEditando == null) {
      await TareasDB.insertar(titulo, desc);
    } else {
      await TareasDB.actualizar(_idEditando!, titulo, desc);
    }
    setState(_limpiarFormulario);
    await _recargarTareas();
  }

  void _cargarParaEditar(Map<String, dynamic> tarea) {
    setState(() {
      _idEditando = tarea['id'] as int;
      _tituloCtrl.text = tarea['titulo'] as String;
      _descCtrl.text = (tarea['descripcion'] ?? '') as String;
    });
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Seguro que quieres eliminar "${tarea['titulo']}"?'),
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
    if (confirmar == true) {
      await TareasDB.eliminar(tarea['id'] as int);
      if (_idEditando == tarea['id']) {
        setState(_limpiarFormulario);
      }
      await _recargarTareas();
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
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Escribe tu nombre'),
        ),
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
      await Preferencias.guardarNombre(nuevo);
      if (!mounted) return;
      setState(() => _nombre = nuevo);
    }
  }

  Future<void> _cambiarFiltro(String filtro) async {
    await Preferencias.guardarFiltro(filtro);
    if (!mounted) return;
    setState(() => _filtro = filtro);
  }

  @override
  Widget build(BuildContext context) {
    final lista = _tareasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
            onPressed: _cambiarNombre,
          ),
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El título es obligatorio';
                      }
                      if (v.trim().length < 3) {
                        return 'Mínimo 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
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
                          onPressed: () => setState(_limpiarFormulario),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'todas', label: Text('Todas')),
              ButtonSegment(value: 'pendientes', label: Text('Pendientes')),
              ButtonSegment(value: 'completadas', label: Text('Completadas')),
            ],
            selected: {_filtro},
            onSelectionChanged: (s) => _cambiarFiltro(s.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final t = lista[i];
                      final completada = t['completada'] == 1;
                      final pendienteSync = t['pendiente_sincronizar'] == 1;
                      return ListTile(
                        leading: Checkbox(
                          value: completada,
                          onChanged: (v) async {
                            await TareasDB.marcarCompletada(
                              t['id'] as int,
                              v ?? false,
                            );
                            await _recargarTareas();
                          },
                        ),
                        title: Text(
                          t['titulo'] as String,
                          style: TextStyle(
                            decoration: completada
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          '${(t['descripcion'] ?? '') as String}'
                          '${pendienteSync ? '\nPendiente de sincronizar' : ''}',
                        ),
                        isThreeLine: pendienteSync,
                        onTap: () => _cargarParaEditar(t),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmarEliminar(t),
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
