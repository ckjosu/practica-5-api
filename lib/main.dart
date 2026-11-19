import 'package:flutter/material.dart';
import 'screens/inicio_screen.dart';
import 'services/notificaciones.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notificaciones.iniciar();
  runApp(const GastosApp());
}

class GastosApp extends StatelessWidget {
  const GastosApp({super.key});
  
  Widget build(BuildContext context) => MaterialApp(
        title: 'Control de Gastos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const InicioScreen(),
      );
}
