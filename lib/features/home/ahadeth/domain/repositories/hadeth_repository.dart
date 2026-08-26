import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';

abstract class HadethRepository {
  Future <Either<ServerException,List<HadethAuthorEntity>>> getHadethAuthor();
  Future <Either<ServerException,List<HadethEntity>>> getHadeth({required String author});
}