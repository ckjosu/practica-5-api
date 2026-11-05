# Práctica 6 (ejercicio evaluable): Gestor offline de tareas

## Objetivo
Desarrollar un gestor de tareas que funcione sin internet, con SQLite para guardar las tareas y SharedPreferences para recordar preferencias de la interfaz.

## Requisitos
- Flutter y Dart instalados
- Dispositivo, emulador o macOS de escritorio
- Paquetes: sqflite, shared_preferences, path

## Instalación
flutter pub get

## Ejecución
flutter run -d macos

## Qué hace la app
- Crear, consultar, editar y eliminar tareas (SQLite).
- Marcar tareas como completadas.
- Filtrar por todas, pendientes o completadas; el filtro se guarda con SharedPreferences.
- Guardar el nombre del usuario con SharedPreferences.
- Validación: el título es obligatorio y debe tener mínimo 3 caracteres.
- Eliminar pide confirmación.
- Funciona sin internet porque todo se guarda en el dispositivo.

## Bandera pendiente_sincronizar
Cada tarea tiene la columna pendiente_sincronizar (1 = pendiente, 0 = enviado). Se pone en 1 al crear, editar o completar una tarea, y sirve para saber qué cambios locales faltan por enviar a un servidor.

## Pruebas
- flutter analyze: sin problemas
- flutter test: todas las pruebas pasan
- Casos manuales: alta, edición, completar, baja con confirmación, filtro y nombre persistentes, y funcionamiento sin conexión

## Participantes
- Josue Hilario Cab Ku
