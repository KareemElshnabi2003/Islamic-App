import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/video/video_services.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';
import 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  final VideoService videoService;
  List<SingleVideoEntity> videos = [];

  VideoPlayerCubit({required this.videoService}) : super(const VideoPlayerState());

  Future<void> init(List<SingleVideoEntity> vids) async {
    videos = vids;
    if (videos.isNotEmpty) {
      await _loadCurrentVideo();
    }
  }

  Future<void> _loadCurrentVideo() async {
    emit(state.copyWith(isLoading: true, isPlaying: false));

    final currentVideoUrl = videos[state.currentIndex].videoUrl;
    await videoService.initVideo(currentVideoUrl);

    videoService.controller?.addListener(_videoListener);

    emit(state.copyWith(isLoading: false));
  }

  void _videoListener() {
    final isPlaying = videoService.controller?.value.isPlaying ?? false;
    if (isPlaying != state.isPlaying) {
      emit(state.copyWith(isPlaying: isPlaying));
    }
  }

  void togglePlay() {
    if (state.isPlaying) {
      videoService.pause();
    } else {
      videoService.play();
    }
  }

  void nextVideo() {
    if (state.currentIndex < videos.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
      _loadCurrentVideo();
    }
  }

  void prevVideo() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
      _loadCurrentVideo();
    }
  }

  @override
  Future<void> close() {
    videoService.dispose();
    return super.close();
  }
}