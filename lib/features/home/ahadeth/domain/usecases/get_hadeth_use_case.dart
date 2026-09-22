import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';

class GetHadethUseCase {
  final HadethRepository hadethRepositories;

  GetHadethUseCase({required this.hadethRepositories});

  Future<Either<ServerException,List<HadethEntity>>> call({required String author, required int page}) async {
    return await hadethRepositories.getHadeth(author: author, page: page);
  }

  Future<Either<ServerException,List<HadethEntity>>> callCached({required String author, required int page}) async {
    return await hadethRepositories.getCachedHadeth(author: author, page: page);
  }
}