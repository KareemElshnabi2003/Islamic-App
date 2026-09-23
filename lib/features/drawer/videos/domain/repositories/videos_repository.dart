import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_entity.dart';

abstract class VideosRepository {
  Future <Either<ServerException,List<VideoEntity>>> getAllVideos();
  Future <Either<ServerException,List<VideoEntity>>> getCachedAllVideos();
}