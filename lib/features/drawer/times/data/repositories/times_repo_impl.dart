import 'dart:convert';

import 'package:fpdart/src/either.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/drawer/times/data/model/times_model.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';
import 'package:islamic_app/features/drawer/times/domain/repositories/times_repository.dart';

class TimesRepoImpl extends TimesRepository  {
final ApiConsumer api;
TimesRepoImpl({required this.api});


  @override
  Future<Either<ServerException, TimesEntity>> getTimes({required double lat, required double lang,required String date}) async{
    String cacheKey = "CACHED_TIMES_AZAN";
    String dateCacheKey = "CACHED_TIMES_DATE";
    try {
      // 1. Check if we already fetched times for TODAY
      final String? cachedDate = CacheHelper.getData(key: dateCacheKey);
      if (cachedDate == date) {
        final cachedData = CacheHelper.getData(key: cacheKey);
        if (cachedData != null) {
          TimesModel times = TimesModel.fromJson(jsonDecode(cachedData));
          return Right(times);
        }
      }

      // 2. If not, fetch from API
      final response = await api.get("${EndPoints.getTimes}/$date?latitude=$lat&longitude=$lang");

      TimesModel times =
         TimesModel.fromJson(response['data']['timings']);

      // 3. Save to cache and update the date
      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(times.toJson()));
      await CacheHelper.saveData(key: dateCacheKey, value: date);

      return Right(times);
    } on ServerException catch (e) {
      return _getCachedTimes(cacheKey, fallbackException: e);
    } catch (e) {
      return _getCachedTimes(
        cacheKey, 
        fallbackException: ServerException(
          errorModel: ErrorModel(
              status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        )
      );
    }
  }

  Either<ServerException, TimesEntity> _getCachedTimes(String key, {required ServerException fallbackException}) {
    try {
      final cachedData = CacheHelper.getData(key: key);
      if (cachedData != null) {
        TimesModel times = TimesModel.fromJson(jsonDecode(cachedData));
        return Right(times);
      }
    } catch (_) {}
    return Left(fallbackException);
  }
}