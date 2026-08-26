
import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/api/api_consumer.dart';

import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/home/radio/data/model/radio_model.dart';
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';
import 'package:islamic_app/features/home/radio/domain/repositories/Radio_repository.dart';

class RadioRepoImpl implements RadioRepository {
  final ApiConsumer api;
  RadioRepoImpl ({required this.api});
  @override
  Future<Either<ServerException, List<RadioEntity>>> getRadioUrls()async {

    try {
      final response = await api.get(EndPoints.getRadioUrl);

      List<RadioModel> radios = (response['radios'] as List)
          .map((json) => RadioModel.fromJson(json))
          .toList();

      return Right(radios);

    } on ServerException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerException(
          errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة البيانات'),
        ),
      );
    }
  }

}