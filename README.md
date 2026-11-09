# Práctica 7: Arquitectura Flutter, componentes, paquetes y optimización

## Objetivo
Estructurar una app de Flutter separando sus responsabilidades en carpetas, usar Provider para el estado, integrar paquetes externos y aplicar prácticas básicas de rendimiento.

## Requisitos
- Flutter y Dart instalados
- Dispositivo, emulador o macOS de escritorio
- Paquetes: provider e intl

## Instalación
flutter pub get

## Ejecución
flutter run -d macos

## Estructura del proyecto
- lib/main.dart: punto de entrada, registra el provider con ChangeNotifierProvider.
- lib/models: modelos de datos.
- lib/services: servicios de la app.
- lib/providers: manejo de estado (ContadorProvider).
- lib/screens: pantallas (PantallaContador).
- lib/widgets: widgets reutilizables (Encabezado, TarjetaContador y BotonAccion).

## Qué hace la app
- Muestra un contador que sube al presionar el botón Incrementar.
- El estado vive en ContadorProvider y la pantalla se actualiza con Consumer.
- Los widgets están separados y usan const donde se puede.

## Paquetes
- provider: manejar el estado de forma sencilla sin mezclarlo con la interfaz.
- intl: formato de fechas y números.

## Pruebas
- flutter analyze: sin problemas
- flutter test: pasan las dos pruebas del ContadorProvider
- Casos manuales: el contador inicia en 0 y suma 1 cada vez que se presiona el botón (capturas en docs/evidencias/practica-07/)

## Participantes
- Josue Hilario Cab Ku
