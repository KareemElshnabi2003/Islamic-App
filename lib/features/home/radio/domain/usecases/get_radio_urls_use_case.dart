import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';
import 'package:islamic_app/features/home/radio/domain/repositories/Radio_repository.dart';

class GetRadioUrlsUseCase {
  final RadioRepository _radioRepo;
  GetRadioUrlsUseCase({required this._radioRepo});

 Future<Either<ServerException,List<RadioEntity>>>call()async{
   return await _radioRepo.getRadioUrls();
 }
}