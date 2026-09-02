import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/quran/domain/entities/all_sour_entity.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';

abstract class QuranRepository {
  Future <Either<ServerException,List<AllSourEntity>>>  getAllSour();
  Future <Either <ServerException,AyatEntity>>  getAyat({required int id});
}