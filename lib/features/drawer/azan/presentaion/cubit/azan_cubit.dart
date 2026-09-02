import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/features/drawer/azan/domain/usecases/get_cached_time_azan_use_case.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';
import 'azan_state.dart';

class AdhanTimerCubit extends Cubit<AdhanTimerState> {
  final GetCachedTimesUseCase getCachedTimesUseCase;
  Timer? _countdownTimer;

  String selectedAudioPath = 'assets/audio/abdelbaset.mp3';
  String selectedAudioName = 'الشيخ عبد الباسط';
  bool isAlarmEnabled = true; // 👈 المتغير اللي بيتحكم في السويتش

  AdhanTimerCubit(this.getCachedTimesUseCase) : super(AdhanTimerInitial());

  void initTimer() async {
    emit(AdhanTimerLoading());

    final prefs = await SharedPreferences.getInstance();
    selectedAudioPath = prefs.getString('AZAN_AUDIO_PATH') ?? 'assets/audio/abdelbaset.mp3';
    selectedAudioName = prefs.getString('AZAN_AUDIO_NAME') ?? 'الشيخ عبد الباسط';
    isAlarmEnabled = prefs.getBool('IS_ALARM_ENABLED') ?? true; // 👈 تحميل حالة السويتش

    final result = await getCachedTimesUseCase();

    result.fold(
          (failure) => emit(AdhanTimerError(failure.errorModel.errorMessage)),
          (timesEntity) => _calculateNextPrayerAndStartTimer(timesEntity),
    );
  }

  // 👈 دالة جديدة عشان تغير حالة السويتش
  void toggleAlarm(bool value) async {
    isAlarmEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IS_ALARM_ENABLED', value);

    if (state is AdhanTimerTicking) {
      final currentState = state as AdhanTimerTicking;
      emit(AdhanTimerTicking(
        nextPrayerName: currentState.nextPrayerName,
        timeRemaining: currentState.timeRemaining,
        selectedAudioName: currentState.selectedAudioName,
        isAlarmEnabled: isAlarmEnabled, // تحديث الشاشة
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

    Map<String, DateTime> prayerDateTimes = {
      "الفجر": _parseTime(times.fajr, now),
      "الظهر": _parseTime(times.duhr, now),
      "العصر": _parseTime(times.asr, now),
      "المغرب": _parseTime(times.magreb, now),
      "العشاء": _parseTime(times.isha, now),
    };

    String? nextPrayerName;
    DateTime? nextPrayerTime;

    for (var entry in prayerDateTimes.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayerName = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }

    if (nextPrayerName == null || nextPrayerTime == null) {
      nextPrayerName = "الفجر";
      nextPrayerTime = prayerDateTimes["الفجر"]!.add(const Duration(days: 1));
    }

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      final difference = nextPrayerTime!.difference(currentTime);

      if (difference.inSeconds <= 0) {
        timer.cancel();
        // 👈 لو السويتش مقفول، مش هيبعت حالة AdhanTimeArrived ومش هيفتح الشاشة السينمائية
        if (isAlarmEnabled) {
          emit(AdhanTimeArrived(prayerName: nextPrayerName!, audioPath: selectedAudioPath));
        } else {
          // لو مقفول، يعيد الحساب للصلاة اللي بعدها صامت
          initTimer();
        }
      } else {
        String hours = difference.inHours.toString().padLeft(2, '0');
        String minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
        String seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');

        emit(AdhanTimerTicking(
          nextPrayerName: nextPrayerName!,
          timeRemaining: "$hours:$minutes:$seconds",
          selectedAudioName: selectedAudioName,
          isAlarmEnabled: isAlarmEnabled, // 👈 بنبعت حالة السويتش
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
    _countdownTimer?.cancel();
    return super.close();
  }
}