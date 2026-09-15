import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/videos/domain/usecases/get_all_videos_use_case.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final GetAllVideosUseCase getAllVideosUseCase;
  VideoCubit({required this.getAllVideosUseCase}) : super(VideoInitial());

  Future<void> getVideos() async {
    emit(VideoLoading());

    final result = await getAllVideosUseCase.call();
    result.fold(
            (failure) {
          if (isClosed) return; // السطر ده للحماية
          emit(VideoError(message: failure.errorModel.errorMessage));
        },
            (videos) {
          if (isClosed) return; // السطر ده للحماية
          emit(VideoSuccess(videos: videos));
        }
    );

  }

}