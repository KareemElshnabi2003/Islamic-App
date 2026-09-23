import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamic_app/features/drawer/azan/data/datasource/azan_local_data_source.dart';
import 'package:islamic_app/features/drawer/azan/data/repositories/azan_time_repo_impl.dart';
import 'package:islamic_app/features/drawer/azan/domain/usecases/get_cached_time_azan_use_case.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

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

      final String audioPath = prefs.getString('AZAN_AUDIO_PATH') ?? 'lib/core/audio/abdelbaset.mp3';
      final String soundFileName = audioPath.split('/').last.split('.').first;
      final String channelId = 'adhan_channel_$soundFileName';

      // تكوين قناة الإشعارات بأقصى صلاحيات مع الصوت المحدد
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        'Adhan Channel',
        description: 'قناة إشعارات الأذان',
        importance: Importance.max,
        enableLights: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundFileName),
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        'Adhan Channel',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundFileName),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      // استخراج اسم الصلاة القادمة لتمريره في الإشعار
      final localDataSource = AdhanLocalDataSourceImpl(prefs);
      final repo = AdhanTimerRepositoryImpl(localDataSource);
      final getCachedTimes = GetCachedTimesUseCase(repo);
      
      String currentPrayerName = "الصلاة";
      
      final result = await getCachedTimes();
      result.fold((l) => null, (times) {
        final now = DateTime.now();
        DateTime parseTime(String timeString, DateTime now) {
          final cleanTime = timeString.split(' ')[0];
          final parts = cleanTime.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
        
        Map<String, DateTime> prayerDateTimes = {
          "الفجر": parseTime(times.fajr, now),
          "الظهر": parseTime(times.duhr, now),
          "العصر": parseTime(times.asr, now),
          "المغرب": parseTime(times.magreb, now),
          "العشاء": parseTime(times.isha, now),
        };

        for (var entry in prayerDateTimes.entries) {
          // Check which prayer is currently happening (within last minute roughly or just triggered)
          if (now.difference(entry.value).inMinutes.abs() <= 2) {
             currentPrayerName = entry.key;
             break;
          }
        }
      });

      // إظهار الإشعار مع تمرير الـ payload عشان يوجهنا لشاشة الأذان بالصلاة الصحيحة
      await flutterLocalNotificationsPlugin.show(
        1,
        'حان الآن موعد صلاة $currentPrayerName',
        'افتح التطبيق لإيقاف الأذان',
        platformChannelSpecifics,
        payload: 'adhan_payload|$currentPrayerName|$audioPath',
      );

      // Reschedule the next adhan
      result.fold((l) => null, (times) {
        final now = DateTime.now();
        DateTime parseTime(String timeString, DateTime now) {
          final cleanTime = timeString.split(' ')[0];
          final parts = cleanTime.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
        
        Map<String, DateTime> prayerDateTimes = {
          "الفجر": parseTime(times.fajr, now),
          "الظهر": parseTime(times.duhr, now),
          "العصر": parseTime(times.asr, now),
          "المغرب": parseTime(times.magreb, now),
          "العشاء": parseTime(times.isha, now),
        };

        DateTime nextPrayerTime = prayerDateTimes["الفجر"]!.add(const Duration(days: 1));

        for (var entry in prayerDateTimes.entries) {
          // add 1 minute to now to ensure we don't pick the current prayer that just triggered
          if (entry.value.isAfter(now.add(const Duration(minutes: 1)))) {
            nextPrayerTime = entry.value;
            break;
          }
        }
        
        AndroidAlarmManager.oneShotAt(
          nextPrayerTime,
          1, // ID ثابت للأذان
          playAdhanInBackground,
          exact: true,
          wakeup: true,
        );
      });

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

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'zekr_channel_id_v3', // غيرنا الـ ID عشان نضمن إنه يتكريت من جديد بنجاح
    'Azkar Channel',
    description: 'قناة إشعارات الأذكار',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'zekr_channel_id_v3',
    'Azkar Channel',
    importance: Importance.max, // عشان يظهر كـ Popup من فوق
    priority: Priority.high,    // عشان يظهر كـ Popup من فوق
    // لو عايز تضيف صوت معين (مثلاً اذكروا الله)
    // 1. ضيف ملف الصوت (مثلاً ozkorallah.mp3) في المسار ده: android/app/src/main/res/raw/ozkorallah.mp3 (لو مجلد raw مش موجود اعمله)
    // 2. شيل الدبل سلاش من السطر اللي تحت:
    // sound: RawResourceAndroidNotificationSound('ozkorallah'),
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    100, // ID مختلف تماماً عن الأذان عشان منع التعارض
    "فاذكروني أذكركم",
    randomZekr,
    platformChannelSpecifics,
  );
}