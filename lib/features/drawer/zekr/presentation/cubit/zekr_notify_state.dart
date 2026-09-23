import 'package:equatable/equatable.dart';

class ZekrNotificationState extends Equatable {
  final bool isEnabled;
  final int interval;
  final String zekrText;

  const ZekrNotificationState({
    this.isEnabled = false,
    this.interval = 30,
    this.zekrText = 'سبحان الله',
  });

  ZekrNotificationState copyWith({
    bool? isEnabled,
    int? interval,
    String? zekrText,
  }) {
    return ZekrNotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      interval: interval ?? this.interval,
      zekrText: zekrText ?? this.zekrText,
    );
  }

  @override
  List<Object?> get props => [isEnabled, interval, zekrText];
}