import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';
import 'package:islamic_app/features/drawer/times/domain/repositories/times_repository.dart';

class GetTimesUseCase {
  final TimesRepository timesRepository;
  GetTimesUseCase({required this.timesRepository});

  Future<Either<ServerException,TimesEntity>> call({required String date,required double lat,required double lang})async{
    return await timesRepository.getTimes(date:date,lat: lat, lang: lang);
  }
}
