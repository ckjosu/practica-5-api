import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings: settings);
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrar(String titulo, String cuerpo) async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_reportes',
        'Reportes',
        channelDescription: 'Avisos de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titulo,
      body: cuerpo,
      notificationDetails: detalles,
    );
  }
}
