import 'dart:convert';
import 'package:fpdart/src/either.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/network/network_info.dart';
import 'package:islamic_app/features/home/ahadeth/data/model/hadeth_author_model.dart';
import 'package:islamic_app/features/home/ahadeth/data/model/hadeth_model.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';


class HadethRepoImpl extends HadethRepository {
  final ApiConsumer api;
  final NetworkInfo networkInfo;

  HadethRepoImpl({
    required this.api,
    required this.networkInfo,
  });

  @override
  Future<Either<ServerException, List<HadethEntity>>> getHadeth({required String author}) async {
    final String cacheKey = "CACHED_HADETH_$author";

    if (await networkInfo.isConnected) {
      try {
        final response = await api.get("${EndPoints.getHadeth}/$author");
        final List dataList = response['data']['hadiths'] as List;

        List<HadethModel> ahadeth = dataList.map((json) => HadethModel.fromjson(json)).toList();

        await CacheHelper.saveData(key: cacheKey, value: jsonEncode(dataList));
        return Right(ahadeth);

      } on ServerException catch (e) {
        return _getCachedHadeth(cacheKey, fallbackException: e);
      }
    } else {
      return _getCachedHadeth(
        cacheKey,
        fallbackException: ServerException(
          errorModel: ErrorModel(status: 503, errorMessage: 'لا يوجد اتصال بالإنترنت'),
        ),
      );
    }
  }

  @override
  Future<Either<ServerException, List<HadethAuthorEntity>>> getHadethAuthor() async {
    const String cacheKey = "CACHED_AUTHORS";

    if (await networkInfo.isConnected) {
      try {
        final response = await api.get(EndPoints.getHadethAuthor);
        final List dataList = response['data'] as List;

        List<HadethAuthorModel> authors = dataList.map((json) => HadethAuthorModel.fromjson(json)).toList();

        await CacheHelper.saveData(key: cacheKey, value: jsonEncode(dataList));
        return Right(authors);

      } on ServerException catch (e) {
        return _getCachedAuthors(cacheKey, fallbackException: e);
      }
    } else {
      return _getCachedAuthors(
        cacheKey,
        fallbackException: ServerException(
          errorModel: ErrorModel(status: 503, errorMessage: 'لا يوجد اتصال بالإنترنت'),
        ),
      );
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