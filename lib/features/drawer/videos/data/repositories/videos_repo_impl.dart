import 'dart:convert';

import 'package:fpdart/src/either.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/end_points.dart';
import 'package:islamic_app/core/errors/error_model.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/videos/data/model/video_model.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_enttiy.dart';
import 'package:islamic_app/features/drawer/videos/domain/repositories/videos_repository.dart';


class VideosRepoImpl  extends VideosRepository{
  final ApiConsumer api;
  VideosRepoImpl({required this.api});


  @override@override
  Future<Either<ServerException, List<VideoEnttiy>>> getAllVideos() async {
    try {
      final response = await api.get(EndPoints.getVideos);

      final List dataList = response['videos'] as List;
      List<VideoModel> allVideos = dataList.map((json) => VideoModel.fromJson(json)).toList();

      return Right(allVideos);
    } on ServerException catch (e) {
      print("=== Server Exception: ${e.errorModel.errorMessage} ===");
      return Left(e);
    } catch (e, stackTrace) {
      print("=== Catch Error: $e ===");
      print("=== StackTrace: $stackTrace ===");
      return Left(ServerException(errorModel: ErrorModel(status: 500, errorMessage: 'حدث خطأ في معالجة بيانات السيرفر')));
    }
  }



}