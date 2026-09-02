import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:islamic_app/core/services/notify/background_notify_services.dart';

import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/get_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/save_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_state.dart';

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
    const int alarmId = 2;

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