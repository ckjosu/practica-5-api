# Práctica 10 - Ejercicio evaluable: Control de Gastos

Alumno: Josue Hilario Cab Ku
Materia: Tópicos de Programación Móvil, grupo 7A, ITESCAM

## Qué hace la app
Sirve para registrar gastos personales. Se guardan en el teléfono con SQLite, se puede agregar la ubicación donde se hizo el gasto y la pestaña "Dólar" muestra el tipo de cambio actual desde una API.

## Pantallas
1. Lista de gastos con el total acumulado.
2. Formulario de nuevo gasto (con validaciones).
3. Detalle del gasto, con opción de eliminar.
4. Tipo de cambio USD a MXN.

## Requisitos que cumple
- Formulario validado: concepto de mínimo 3 caracteres, monto mayor a 0 y categoría.
- Consumo de API REST: open.er-api.com, con estados de carga y error y botón de reintentar.
- Persistencia local: SQLite con sqflite (la lista funciona sin internet).
- Capacidad del dispositivo: ubicación con geolocator.
- Notificación local al guardar un gasto.

## Cómo ejecutarlo
    flutter pub get
    flutter run

## Estructura
- lib/models: modelo Gasto
- lib/services: base de datos, API, ubicación y notificaciones
- lib/screens: pantallas de la app

## Evidencias
Capturas en docs/evidencias/practica-10-ejercicio/
