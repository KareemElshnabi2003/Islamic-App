import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =======================================================
// 1. دالة تشغيل الأذان في الخلفية (إيقاظ الشاشة والإشعار فقط)
// =======================================================
@pragma('vm:entry-point')
void playAdhanInBackground() async {
  // التأكد من تهيئة بيئة الفلاتر والخلفية
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  debugPrint("🔔 ⏰ WAKE UP! Background Adhan is Triggered!");

  final prefs = await SharedPreferences.getInstance();
  bool isAlarmEnabled = prefs.getBool('IS_ALARM_ENABLED') ?? true;

  if (isAlarmEnabled) {
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // تكوين قناة الإشعارات بأقصى صلاحيات (عشان تقدر تكسر قفل الشاشة وتنورها)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'adhan_channel_id',
        'Adhan Channel',
        description: 'قناة إشعارات الأذان',
        importance: Importance.max,
        enableLights: true,
        playSound: false,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'adhan_channel_id',
        'Adhan Channel',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true, // 👈 السحر اللي بينور الشاشة والموبايل مقفول
        playSound: false,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      // إظهار الإشعار غصب عن النظام مع تمرير الـ payload عشان يوجهنا لشاشة الأذان
      await flutterLocalNotificationsPlugin.show(
        1,
        'حان الآن موعد الصلاة',
        'افتح التطبيق لإيقاف الأذان',
        platformChannelSpecifics,
        payload: 'adhan_payload',
      );

      // ملحوظة هامة: تم فصل تشغيل الصوت نهائياً من هنا لكي لا يحدث تداخل أو صوت مزدوج.
      // الصوت سيتم تشغيله مباشرة داخل (AdhanAudioScreen) أول ما التطبيق يفتح وتتحول الواجهة.
    } catch (e) {
      debugPrint("Background Adhan Error: $e");
    }
  }
}

// =======================================================
// 2. دالة إشعارات الأذكار في الخلفية (اختيارية حسب مشروعك)
// =======================================================
@pragma('vm:entry-point')
void backgroundZekrTask() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final List<String> azkar = [
    "سبحان الله",
    "الحمد لله",
    "لا إله إلا الله",
    "الله أكبر",
    "لا حول ولا قوة إلا بالله",
    "أستغفر الله وأتوب إليه",
    "سبحان الله وبحمده",
    "سبحان الله العظيم",
    "اللهم صل وسلم على نبينا محمد",
    "حسبي الله ونعم الوكيل",
    "لا إله إلا أنت سبحانك إني كنت من الظالمين",
  ];

  final random = Random();
  final String randomZekr = azkar[random.nextInt(azkar.length)];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'zekr_channel_id',
    'Azkar Channel',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    100, // ID مختلف تماماً عن الأذان عشان منع التعارض
    "فاذكروني أذكركم",
    randomZekr,
    platformChannelSpecifics,
  );
}