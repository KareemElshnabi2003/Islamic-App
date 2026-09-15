import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';

abstract class  TimesRepository {


  Future <Either<ServerException,TimesEntity>> getTimes({required String date,required double lat,required double lang});

}