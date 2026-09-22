import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/doaa/data/model/categories_model.dart';
import 'package:islamic_app/features/drawer/doaa/data/model/doaa_model.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/categories_entity.dart';
import 'package:islamic_app/features/drawer/doaa/domain/repositories/doaa_repository.dart';

class DoaaRepoImpl extends DoaaRepository {
  final ApiConsumer api;

  DoaaRepoImpl({required this.api});

  @override
  Future<Either<ServerException, List<CategoriesEntity>>> getCategoriesWithDuas() async {
    try {
      final response = await api.get(EndPoints.getAllDoaa);
      
      // حفظ النسخة المحلية
      CacheHelper.saveData(key: 'CACHED_DOAA_RESPONSE', value: jsonEncode(response));

      return Right(_parseCategories(response['data']));
    } on ServerException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerException(
          errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        ),
      );
    }
  }

  @override
  Future<Either<ServerException, List<CategoriesEntity>>> getCachedCategoriesWithDuas() async {
    try {
      final cachedStr = CacheHelper.getData(key: 'CACHED_DOAA_RESPONSE');
      if (cachedStr != null) {
        final response = jsonDecode(cachedStr);
        return Right(_parseCategories(response['data']));
      }
      return Left(
        ServerException(
          errorModel: ErrorModel(status: 404, errorMessage: 'لا توجد بيانات محفوظة'),
        ),
      );
    } catch (e) {
      return Left(
        ServerException(
          errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في قراءة البيانات المحفوظة'),
        ),
      );
    }
  }

  List<CategoriesEntity> _parseCategories(dynamic data) {
    final List categoriesJson = data['categories'];
    final List duasJson = data['duas'];

    List<DoaaModel> allDuas = duasJson.map((e) => DoaaModel.fromJson(e)).toList();

    return categoriesJson.map((catJson) {
      String catId = catJson['id'];
      List<DoaaModel> catDuas = allDuas.where((dua) => dua.categoryId == catId).toList();
      return CategoriesModel.fromJson(catJson, catDuas);
    }).toList();
  }
}