
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/api/api_consumer.dart';

import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/home/radio/data/model/radio_model.dart';
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';
import 'package:islamic_app/features/home/radio/domain/repositories/radio_repository.dart';

class RadioRepoImpl implements RadioRepository {
  final ApiConsumer api;
  RadioRepoImpl ({required this.api});
  @override
  Future<Either<ServerException, List<RadioEntity>>> getRadioUrls()async {
    const String cacheKey = "CACHED_RADIOS";
    try {
      final response = await api.get(EndPoints.getRadioUrl);

      List<RadioModel> radios = (response['radios'] as List)
          .map((json) => RadioModel.fromJson(json))
          .toList();

      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(response['radios']));

      return Right(radios);

    } on ServerException catch (e) {
      return _getCachedRadios(cacheKey, fallbackException: e);
    } catch (e) {
      return _getCachedRadios(
        cacheKey,
        fallbackException: ServerException(
          errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        )
      );
    }
  }

  @override
  Future<Either<ServerException, List<RadioEntity>>> getCachedRadioUrls() async {
    return _getCachedRadios("CACHED_RADIOS", fallbackException: ServerException(
      errorModel: ErrorModel(status: 404, errorMessage: 'لا توجد بيانات محفوظة'),
    ));
  }

  Either<ServerException, List<RadioEntity>> _getCachedRadios(String key, {required ServerException fallbackException}) {
    try {
      final cachedData = CacheHelper.getData(key: key);
      if (cachedData != null) {
        List<RadioModel> radios = (jsonDecode(cachedData) as List)
            .map((json) => RadioModel.fromJson(json))
            .toList();
        return Right(radios);
      }
    } catch (_) {}
    return Left(fallbackException);
  }
}