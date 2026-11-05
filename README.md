# Práctica 6: Persistencia local y funcionamiento offline

## Objetivo
Guardar preferencias simples con SharedPreferences y registros estructurados con SQLite (sqflite), con operaciones CRUD y funcionamiento sin conexión.

## Requisitos
- Flutter y Dart instalados
- Dispositivo, emulador o macOS de escritorio
- Paquetes: sqflite, shared_preferences, path

## Instalación
flutter pub get

## Ejecución
flutter run -d macos

## Qué hace la app
- Crear, listar, editar y eliminar notas con SQLite.
- Eliminar pide confirmación con un diálogo.
- Guarda el nombre del usuario con SharedPreferences y lo muestra al iniciar.
- Funciona sin internet porque todo se guarda en el dispositivo.

## Bandera pendiente_sincronizar
Para saber qué cambios locales aún no se envían a un servidor, cada registro tendría una columna pendiente_sincronizar (1 = pendiente, 0 = enviado). Al crear o editar se pone en 1, y cuando el servidor confirma la sincronización se cambia a 0.

## Pruebas
- flutter analyze: sin problemas
- flutter test: todas las pruebas pasan
- Casos manuales: alta, edición, baja con confirmación, nombre persistente después de reiniciar y notas disponibles sin conexión (capturas en docs/evidencias/practica-06/)

## Participantes
- Josue Hilario Cab Ku
