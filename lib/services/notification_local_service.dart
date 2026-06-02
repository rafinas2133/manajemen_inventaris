import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app.dart';

class LocalNotificationService {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notif.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // 🔥 TAP NOTIF (FOREGROUND)
        navigatorKey.currentState?.pushNamed('/notifications');
      },
    );

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for important notifications',
      importance: Importance.max,
    );

    await _notif
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'logo',
      ),
    );

    await _notif.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
