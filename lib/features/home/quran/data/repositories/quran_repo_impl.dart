import 'dart:convert';

import 'package:fpdart/src/either.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/home/quran/data/model/all_sour_model.dart';
import 'package:islamic_app/features/home/quran/data/model/ayat_model.dart';
import 'package:islamic_app/features/home/quran/domain/entities/all_sour_entity.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';
import 'package:islamic_app/features/home/quran/domain/repositories/quran_repository.dart';

class QuranRepoImpl  extends QuranRepository{
  final ApiConsumer api;
  QuranRepoImpl({required this.api});
  @override
  Future<Either<ServerException, List<AllSourEntity>>> getAllSour()async {
    const String cacheKey = "CACHED_QURAN_SOUR";

    try {
      final response = await api.get(EndPoints.getSour);

      final List dataList = response['suwar'] as List;
      List<AllSourModel> authors = dataList.map((json) => AllSourModel.fromJson(json)).toList();

      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(dataList));
      return Right(authors);

    } on ServerException catch (e) {
      return _getCachedSour(cacheKey, fallbackException: e);
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة بيانات السيرفر')));
    }
  }

  @override
  Future<Either<ServerException, AyatEntity>> getAyat({required int id}) async{
     String cacheKey = "CACHED_QURAN_SOUR_$id";

    try {
      final response = await api.get("${EndPoints.getAyat}/$id");

      final Map<String,dynamic> data = response['data'] ;
      AyatModel ayat =  AyatModel.fromJson(data);

      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(data));
      return Right(ayat);

    } on ServerException catch (e) {
      return _getCachedAyat(cacheKey, fallbackException: e);
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة بيانات السيرفر')));
    }
  }
  Either<ServerException, List<AllSourEntity>> _getCachedSour(String key, {required ServerException fallbackException}) {
    final cachedData = CacheHelper.getData(key: key);
    if (cachedData != null) {
      List<AllSourEntity> authors = (jsonDecode(cachedData) as List)
          .map((json) => AllSourModel.fromJson(json))
          .toList();
      return Right(authors);
    }
    return Left(fallbackException);
  }

  Either<ServerException,AyatModel> _getCachedAyat(String key, {required ServerException fallbackException}) {
    final cachedData = CacheHelper.getData(key: key);
    if (cachedData != null) {
      AyatModel ayat =
        AyatModel.fromJson(cachedData);
      return Right(ayat);
    }
    return Left(fallbackException);
  }

}