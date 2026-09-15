import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';
import 'package:islamic_app/features/home/quran/domain/repositories/quran_repository.dart';

class GetAyatUseCase {
  final QuranRepository quranRepository;
  const GetAyatUseCase({required this.quranRepository});

  Future <Either<ServerException ,AyatEntity>> call({required int id })async{
    return await quranRepository.getAyat(id: id);
  }
}