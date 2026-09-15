import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocalNotifyService {
  Future<void> init();
  Future<void> showNotification({required int id, required String title, required String body});
  Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate});
}

class LocalNotifyServiceImpl implements LocalNotifyService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Future<void> showNotification({required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'islamic_channel_id', 'Islamic App Notifications',
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  @override
  Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate}) async {
    // هنا سيتم دمج timezone لجدولة الإشعارات (للأذان أو الأذكار)
  }
}