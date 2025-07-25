import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showVisitNotification(String marketName) async {
    const androidDetails = AndroidNotificationDetails(
      'canal_visita_id',
      'Visita a Mercados',
      channelDescription: 'Notifica proximidade com mercados',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Você está perto de $marketName!',
      'Deseja marcar como visitado?',
      notificationDetails,
    );
  }
}
