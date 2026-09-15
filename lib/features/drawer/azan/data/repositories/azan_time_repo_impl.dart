
import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/azan/data/datasource/azan_local_data_source.dart';
import 'package:islamic_app/features/drawer/azan/domain/repositories/azan_repository.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';


class AdhanTimerRepositoryImpl implements BaseAdhanTimerRepository {
  final BaseAdhanLocalDataSource localDataSource;

  AdhanTimerRepositoryImpl(this.localDataSource);

  @override
  Future<Either<ServerException, TimesEntity>> getCachedTimes() async {
    try {
      final times = await localDataSource.getCachedPrayerTimes();
      return Right(times);
    }on ServerException catch (e) {
      return Left(e);
    }catch (e) {
      return Left(
        ServerException(
          errorModel: ErrorModel(
              status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        ),
      );
    }
  }
}