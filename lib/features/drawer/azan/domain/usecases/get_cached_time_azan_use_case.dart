import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/azan/domain/repositories/azan_repository.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';

class GetCachedTimesUseCase {
  final BaseAdhanTimerRepository repository;

  GetCachedTimesUseCase(this.repository);

  Future<Either<ServerException, TimesEntity>> call() async {
    return await repository.getCachedTimes();
  }
}