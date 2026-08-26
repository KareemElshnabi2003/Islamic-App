import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';

abstract class RadioRepository {

  Future <Either<ServerException,List<RadioEntity>>> getRadioUrls();

}