import 'package:intl/intl.dart';

class Registro {
  final String rutaFoto;
  final DateTime fecha;
  final List<double> acelerometro;
  final List<double> giroscopio;

  const Registro({
    required this.rutaFoto,
    required this.fecha,
    required this.acelerometro,
    required this.giroscopio,
  });

  String get fechaTexto => DateFormat('dd/MM/yyyy HH:mm:ss').format(fecha);

  static String vector(List<double> v) =>
      'X: ${v[0].toStringAsFixed(2)}  Y: ${v[1].toStringAsFixed(2)}  Z: ${v[2].toStringAsFixed(2)}';
}
