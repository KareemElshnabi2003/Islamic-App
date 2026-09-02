import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/categories_entity.dart';
import 'package:islamic_app/features/drawer/doaa/domain/repositories/doaa_repository.dart';

class GetCategoriesUseCase {
  final DoaaRepository doaaRepository;

  GetCategoriesUseCase({required this.doaaRepository});

  Future<Either<ServerException, List<CategoriesEntity>>> call() async {
    return await doaaRepository.getCategoriesWithDuas();
  }
}