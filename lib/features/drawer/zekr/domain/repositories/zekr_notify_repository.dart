import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';

abstract class ZekrSettingsRepository {
  Future<Either<ServerException, ZekrSettingsEntity>> getSettings();
  Future<Either<ServerException, void>> saveSettings(ZekrSettingsEntity settings);
}