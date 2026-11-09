import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'screens/pantalla_contador.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContadorProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const morado = Color(0xFF7C4DFF);
    const rosa = Color(0xFFFF4081);

    return MaterialApp(
      title: 'Práctica 7',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: morado, secondary: rosa),
        scaffoldBackgroundColor: const Color(0xFFF3EEFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: morado,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: rosa,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const PantallaContador(),
    );
  }
}
