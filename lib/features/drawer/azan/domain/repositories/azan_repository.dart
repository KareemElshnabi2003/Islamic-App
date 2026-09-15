import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';

abstract class BaseAdhanTimerRepository {
  Future<Either<ServerException, TimesEntity>> getCachedTimes();
}