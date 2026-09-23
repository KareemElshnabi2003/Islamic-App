import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_entity.dart';
import 'package:islamic_app/features/drawer/videos/domain/repositories/videos_repository.dart';

class GetAllVideosUseCase {
  final VideosRepository videosRepository;

   GetAllVideosUseCase({required this.videosRepository});
  Future<Either<ServerException,List<VideoEntity>>> call()async{
    return await videosRepository.getAllVideos();
  }
  
  Future<Either<ServerException,List<VideoEntity>>> callCached()async{
    return await videosRepository.getCachedAllVideos();
  }
}