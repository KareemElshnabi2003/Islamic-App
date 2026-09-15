import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/zekr/domain/entities/zekr_notify_entity.dart';
import 'package:islamic_app/features/drawer/zekr/domain/repositories/zekr_notify_repository.dart';

class GetZekrSettingsUseCase {
  final ZekrSettingsRepository repository;

  GetZekrSettingsUseCase({required this.repository});

  Future<Either<ServerException, ZekrSettingsEntity>> call() async {
    return await repository.getSettings();
  }
}