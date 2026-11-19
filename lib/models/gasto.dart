import 'package:intl/intl.dart';

class Gasto {
  final int? id;
  final String concepto;
  final double monto;
  final String categoria;
  final double? latitud;
  final double? longitud;
  final DateTime fecha;

  Gasto({
    this.id,
    required this.concepto,
    required this.monto,
    required this.categoria,
    this.latitud,
    this.longitud,
    required this.fecha,
  });

  String get fechaTexto => DateFormat('dd/MM/yyyy HH:mm').format(fecha);

  Map<String, Object?> toMap() => {
        'id': id,
        'concepto': concepto,
        'monto': monto,
        'categoria': categoria,
        'latitud': latitud,
        'longitud': longitud,
        'fecha': fecha.toIso8601String(),
      };

  factory Gasto.fromMap(Map<String, Object?> m) => Gasto(
        id: m['id'] as int?,
        concepto: m['concepto'] as String,
        monto: (m['monto'] as num).toDouble(),
        categoria: m['categoria'] as String,
        latitud: (m['latitud'] as num?)?.toDouble(),
        longitud: (m['longitud'] as num?)?.toDouble(),
        fecha: DateTime.parse(m['fecha'] as String),
      );
}
