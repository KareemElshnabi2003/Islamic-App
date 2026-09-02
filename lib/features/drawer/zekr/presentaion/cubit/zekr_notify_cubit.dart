import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:islamic_app/core/services/notify/local_notify_service.dart';
import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/get_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/save_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_state.dart';


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
    "سبحان الله وبحمده، سبحان الله العظيم",
    "يا حي يا قيوم برحمتك أستغيث",
    "اللهم إنك عفو تحب العفو فاعف عني",
    "رضيت بالله رباً وبالإسلام ديناً وبمحمد ﷺ نبياً",
  ];

  final random = Random();
  final String randomZekr = azkar[random.nextInt(azkar.length)];

  final notifyService = LocalNotifyServiceImpl();
  await notifyService.init();

  await notifyService.showNotification(
    id: 100,
    title: "فاذكروني أذكركم",
    body: randomZekr,
  );
}


class ZekrNotificationCubit extends Cubit<ZekrNotificationState> {
  final GetZekrSettingsUseCase getZekrSettingsUseCase;
  final SaveZekrSettingsUseCase saveZekrSettingsUseCase;

  ZekrNotificationCubit({
    required this.getZekrSettingsUseCase,
    required this.saveZekrSettingsUseCase,
  }) : super(const ZekrNotificationState());

  Future<void> loadSettings() async {
    final result = await getZekrSettingsUseCase.call();
    result.fold(
          (failure) => null,
          (settings) {
        emit(state.copyWith(
          isEnabled: settings.isEnabled,
          interval: settings.interval,

        ));
      },
    );
  }

  void toggleNotification(bool value) {
    emit(state.copyWith(isEnabled: value));
    _saveCurrentSettings();
    _handleAlarmState();
  }

  void changeInterval(int interval) {
    emit(state.copyWith(interval: interval));
    _saveCurrentSettings();
    _handleAlarmState();
  }

  void _saveCurrentSettings() {
    final settings = ZekrSettingsEntity(
      isEnabled: state.isEnabled,
      interval: state.interval,
      zekrText: "",
    );
    saveZekrSettingsUseCase.call(settings);
  }
  void _handleAlarmState() async {
    const int alarmId = 1;

    if (state.isEnabled) {
      await AndroidAlarmManager.cancel(alarmId);

      // رجعناها periodic عشان تشتغل كل فترة بناءً على اختيار اليوزر
      await AndroidAlarmManager.periodic(
        Duration(minutes: state.interval), // الوقت اللي اليوزر اختاره
        alarmId,
        backgroundZekrTask,
        exact: true,
        wakeup: true,
      );

    } else {
      await AndroidAlarmManager.cancel(alarmId);
    }
  }
}