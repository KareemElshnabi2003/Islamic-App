import 'dart:convert';
import 'package:fpdart/src/either.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/home/ahadeth/data/model/hadeth_author_model.dart';
import 'package:islamic_app/features/home/ahadeth/data/model/hadeth_model.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';

class HadethRepoImpl extends HadethRepository {
  final ApiConsumer api;

  HadethRepoImpl({
    required this.api,
  });

  @override
  Future<Either<ServerException, List<HadethEntity>>> getHadeth({required String author, required int page}) async {
    final String cacheKey = "CACHED_HADETH_${author}_$page";

    try {
      final response = await api.get("${EndPoints.getHadeth}/$author?page=$page");

      List dataList = [];
      if (response['data'] is List) {
        dataList = response['data'];
      } else if (response['data'] is Map) {
        if (response['data']['hadiths'] != null) {
          dataList = response['data']['hadiths'] as List;
        } else if (response['data']['data'] != null) {
          dataList = response['data']['data'] as List;
        } else {
          dataList = (response['data'] as Map).values.toList();
        }
      }

      List<HadethModel> ahadeth = dataList.map((json) => HadethModel.fromjson(json)).toList();
      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(dataList));
      return Right(ahadeth);

    } on ServerException catch (e) {
      return _getCachedHadeth(cacheKey, fallbackException: e);
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة الأحاديث')));
    }
  }

  @override
  Future<Either<ServerException, List<HadethAuthorEntity>>> getHadethAuthor() async {
    const String cacheKey = "CACHED_AUTHORS";

    try {
      final response = await api.get(EndPoints.getHadethAuthor);

      final List dataList = response['data']['collections'] as List;
      List<HadethAuthorModel> authors = dataList.map((json) => HadethAuthorModel.fromjson(json)).toList();

      await CacheHelper.saveData(key: cacheKey, value: jsonEncode(dataList));
      return Right(authors);

    } on ServerException catch (e) {
      return _getCachedAuthors(cacheKey, fallbackException: e);
    } catch (e) {
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة بيانات السيرفر')));
    }
  }


  Either<ServerException, List<HadethEntity>> _getCachedHadeth(String key, {required ServerException fallbackException}) {
    final cachedData = CacheHelper.getData(key: key);
    if (cachedData != null) {
      List<HadethModel> ahadeth = (jsonDecode(cachedData) as List)
          .map((json) => HadethModel.fromjson(json))
          .toList();
      return Right(ahadeth);
    }
    return Left(fallbackException);
  }

  Either<ServerException, List<HadethAuthorEntity>> _getCachedAuthors(String key, {required ServerException fallbackException}) {
    final cachedData = CacheHelper.getData(key: key);
    if (cachedData != null) {
      List<HadethAuthorModel> authors = (jsonDecode(cachedData) as List)
          .map((json) => HadethAuthorModel.fromjson(json))
          .toList();
      return Right(authors);
    }
    return Left(fallbackException);
  }
}