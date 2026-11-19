import 'package:intl/intl.dart';

class Reporte {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? rutaFoto;
  final double? latitud;
  final double? longitud;
  final DateTime fecha;

  const Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.rutaFoto,
    this.latitud,
    this.longitud,
    required this.fecha,
  });

  String get fechaTexto => DateFormat('dd/MM/yyyy HH:mm').format(fecha);

  Map<String, Object?> toMap() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'ruta_foto': rutaFoto,
        'latitud': latitud,
        'longitud': longitud,
        'fecha': fecha.toIso8601String(),
      };

  factory Reporte.fromMap(Map<String, Object?> m) => Reporte(
        id: m['id'] as int?,
        titulo: m['titulo'] as String,
        descripcion: m['descripcion'] as String,
        categoria: m['categoria'] as String,
        rutaFoto: m['ruta_foto'] as String?,
        latitud: m['latitud'] as double?,
        longitud: m['longitud'] as double?,
        fecha: DateTime.parse(m['fecha'] as String),
      );
}
