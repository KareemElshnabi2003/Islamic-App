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
    try {
      String cacheKey = "CACHED_TIMES_AZAN";

      final response = await api.get("${EndPoints.getTimes}/$date?latitude=$lat&longitude=$lang");

      TimesModel times =
         TimesModel.fromJson(response['data']['timings']);

      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(times));


      return Right(times);
    } on ServerException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerException(
          errorModel: ErrorModel(
              status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        ),
      );
    }

  }
}