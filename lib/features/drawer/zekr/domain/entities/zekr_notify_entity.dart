import 'package:equatable/equatable.dart';

class ZekrSettingsEntity extends Equatable {
  final bool isEnabled; // الزرار مفتوح ولا مقفول
  final int interval; // الوقت بالدقائق
  final String zekrText; // الذكر المختار

  const ZekrSettingsEntity({
    required this.isEnabled,
    required this.interval,
    required this.zekrText,
  });

  @override
  List<Object?> get props => [isEnabled, interval, zekrText];
}