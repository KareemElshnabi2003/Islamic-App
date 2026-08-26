import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';

class GetHadethAuthorUseCase {
  final HadethRepository hadethRepositories;

  GetHadethAuthorUseCase({required this.hadethRepositories});

  Future <Either<ServerException,List<HadethAuthorEntity>>> call(){
    return hadethRepositories.getHadethAuthor();
}

}