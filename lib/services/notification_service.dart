import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // 👉 Handle notification tap
        print("Notification tapped: ${response.payload}");
      },
    );
  }

  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'leave_channel',
      'Leave Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }
}