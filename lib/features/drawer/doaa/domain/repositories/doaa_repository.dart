import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/categories_entity.dart';

abstract class DoaaRepository {
  Future<Either<ServerException, List<CategoriesEntity>>> getCategoriesWithDuas();
}