import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'; // 👈 استدعاء الباكدج
// تأكد من مسار الملف اللي لسه عاملينه
import 'package:islamic_app/features/drawer/azan/domain/usecases/get_cached_time_azan_use_case.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';
import '../../../../../core/services/notify/background_notify_services.dart';
import 'azan_state.dart';

class AdhanTimerCubit extends Cubit<AdhanTimerState> {
  final GetCachedTimesUseCase getCachedTimesUseCase;
  Timer? _countdownTimer;

  String selectedAudioPath = AppAudio.abdelbaset;
  String selectedAudioName = 'الشيخ عبد الباسط';
  bool isAlarmEnabled = true;

  AdhanTimerCubit(this.getCachedTimesUseCase) : super(AdhanTimerInitial());

  void initTimer() async {
    emit(AdhanTimerLoading());
    final prefs = await SharedPreferences.getInstance();
    selectedAudioPath = prefs.getString('AZAN_AUDIO_PATH') ??AppAudio.abdelbaset;
    selectedAudioName = prefs.getString('AZAN_AUDIO_NAME') ?? 'الشيخ عبد الباسط';
    isAlarmEnabled = prefs.getBool('IS_ALARM_ENABLED') ?? true;

    final result = await getCachedTimesUseCase();
    result.fold(
          (failure) => emit(AdhanTimerError(failure.errorModel.errorMessage)),
          (timesEntity) => _calculateNextPrayerAndStartTimer(timesEntity),
    );
  }

  void toggleAlarm(bool value) async {
    isAlarmEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IS_ALARM_ENABLED', value);

    // 🔴 لو اليوزر قفل المنبه، نلغي الجدولة من الخلفية
    if (!value) {
      await AndroidAlarmManager.cancel(1); // 1 هو الـ ID بتاع الأذان
    } else {
      initTimer(); // نعيد الحساب والجدولة
    }

    if (state is AdhanTimerTicking) {
      final currentState = state as AdhanTimerTicking;
      emit(AdhanTimerTicking(
        nextPrayerName: currentState.nextPrayerName,
        timeRemaining: currentState.timeRemaining,
        selectedAudioName: currentState.selectedAudioName,
        isAlarmEnabled: isAlarmEnabled,
      ));
    }
  }

  void changeSheikh(String name, String path) async {
    selectedAudioName = name;
    selectedAudioPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AZAN_AUDIO_NAME', name);
    await prefs.setString('AZAN_AUDIO_PATH', path);

    if (state is AdhanTimerTicking) {
      final currentState = state as AdhanTimerTicking;
      emit(AdhanTimerTicking(
        nextPrayerName: currentState.nextPrayerName,
        timeRemaining: currentState.timeRemaining,
        selectedAudioName: selectedAudioName,
        isAlarmEnabled: isAlarmEnabled,
      ));
    }
  }

  void _calculateNextPrayerAndStartTimer(TimesEntity times) {
    final now = DateTime.now();

    // 🛑 1. احساب أوقات الصلاة الحقيقية
    Map<String, DateTime> prayerDateTimes = {
      "الفجر": _parseTime(times.fajr, now),
      "الظهر": _parseTime(times.duhr, now),
      "العصر": _parseTime(times.asr, now),
      "المغرب": _parseTime(times.magreb, now),
      "العشاء": _parseTime(times.isha, now),
    };

    String nextPrayerName = "الفجر";
    DateTime nextPrayerTime = prayerDateTimes["الفجر"]!.add(const Duration(days: 1));

    for (var entry in prayerDateTimes.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayerName = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }

    // // 🧪 (مؤقت للتيست: شيل السطرين اللي تحت دول لما تخلص تجربة وتعتمد على أوقات الصلاة الحقيقية)
    // nextPrayerTime = DateTime.now().add(const Duration(seconds: 15));
    // nextPrayerName = "التجربة";

    // 🚀 2. الجدولة الحقيقية عند نظام الأندرويد (تشتغل والموبايل مقفول أو التطبيق مقفول)
    if (isAlarmEnabled) {
      // بنلغي أي ألارم قديم بنفس الـ ID (1) عشان منع التداخل
      AndroidAlarmManager.cancel(1);

      AndroidAlarmManager.oneShotAt(
        nextPrayerTime,
        1, // ID ثابت للأذان
        playAdhanInBackground,
        exact: true,
        wakeup: true, // بيصحى الموبايل لو الشاشة مطفية
      );
    }

    // 🎨 3. العداد الشكلي المرئي (شغال طول ما اليوزر واقف في صفحة التوقيت فقط)
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      final difference = nextPrayerTime.difference(currentTime);

      if (difference.inSeconds <= 0) {
        timer.cancel();
        if (isAlarmEnabled) {
          emit(AdhanTimeArrived(prayerName: nextPrayerName, audioPath: selectedAudioPath));
        } else {
          initTimer();
        }
      } else {
        String hours = difference.inHours.toString().padLeft(2, '0');
        String minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
        String seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');

        emit(AdhanTimerTicking(
          nextPrayerName: nextPrayerName,
          timeRemaining: "$hours:$minutes:$seconds",
          selectedAudioName: selectedAudioName,
          isAlarmEnabled: isAlarmEnabled,
        ));
      }
    });
  }

  DateTime _parseTime(String timeString, DateTime now) {
    final cleanTime = timeString.split(' ')[0];
    final parts = cleanTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel(); // 👈 لازم نلغي التايمر أول ما الكيوبيت يقفل
    return super.close();
  }
}