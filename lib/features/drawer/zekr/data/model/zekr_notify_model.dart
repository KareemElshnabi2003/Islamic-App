import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';

class ZekrSettingsModel extends ZekrSettingsEntity {
  const ZekrSettingsModel({
    required super.isEnabled,
    required super.interval,
    required super.zekrText,
  });

  factory ZekrSettingsModel.fromJson(Map<String, dynamic> json) {
    return ZekrSettingsModel(
      isEnabled: json['isEnabled'] ?? false, // الديفولت مقفول
      interval: json['interval'] ?? 30, // الديفولت 30 دقيقة
      zekrText: json['zekrText'] ?? 'سبحان الله', // الديفولت سبحان الله
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'interval': interval,
      'zekrText': zekrText,
    };
  }
}