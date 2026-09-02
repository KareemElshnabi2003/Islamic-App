import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/drawer/zekr/data/model/zekr_notify_model.dart';
import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';
import 'package:islamic_app/features/drawer/zekr/domain/repositories/zekr_notify_repository.dart';


class ZekrSettingsRepoImpl implements ZekrSettingsRepository {

  @override
  Future<Either<ServerException, ZekrSettingsEntity>> getSettings() async {
    try {
      final jsonString = CacheHelper.getData(key: 'zekr_settings');
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString);
        return Right(ZekrSettingsModel.fromJson(jsonMap));
      } else {
        return const Right(ZekrSettingsModel(isEnabled: false, interval: 30, zekrText: 'سبحان الله'));
      }
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'خطأ في قراءة الذاكرة')));
    }
  }

  @override
  Future<Either<ServerException, void>> saveSettings(ZekrSettingsEntity settings) async {
    try {
      final model = ZekrSettingsModel(
        isEnabled: settings.isEnabled,
        interval: settings.interval,
        zekrText: settings.zekrText,
      );
      final jsonString = jsonEncode(model.toJson());
      await CacheHelper.saveData(key: 'zekr_settings', value: jsonString);
      return const Right(null);
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'خطأ في حفظ البيانات')));
    }
  }
}