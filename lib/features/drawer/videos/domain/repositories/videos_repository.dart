import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_enttiy.dart';

abstract class VideosRepository {
  Future <Either<ServerException,List<VideoEnttiy>>> getAllVideos();
}