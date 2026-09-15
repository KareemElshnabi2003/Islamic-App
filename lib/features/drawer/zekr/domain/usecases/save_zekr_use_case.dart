import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';
import 'package:islamic_app/features/drawer/zekr/domain/repositories/zekr_notify_repository.dart';

class SaveZekrSettingsUseCase {
  final ZekrSettingsRepository repository;

  SaveZekrSettingsUseCase({required this.repository});

  Future<Either<ServerException, void>> call(ZekrSettingsEntity settings) async {
    return await repository.saveSettings(settings);
  }
}