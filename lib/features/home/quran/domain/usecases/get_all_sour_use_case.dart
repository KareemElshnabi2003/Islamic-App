import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/quran/domain/entities/all_sour_entity.dart';
import 'package:islamic_app/features/home/quran/domain/repositories/quran_repository.dart';

class GetAllSourUseCase {
  final QuranRepository quranRepository;
  const GetAllSourUseCase({required this.quranRepository});

  Future <Either<ServerException ,List<AllSourEntity>>> call()async{
    return await quranRepository.getAllSour();
  }
}