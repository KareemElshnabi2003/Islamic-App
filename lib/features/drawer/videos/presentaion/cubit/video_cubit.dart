import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/videos/domain/usecases/get_all_videos_use_case.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final GetAllVideosUseCase getAllVideosUseCase;
  VideoCubit({required this.getAllVideosUseCase}) : super(VideoInitial());

  Future<void> getVideos() async {
    bool hasEmittedCache = false;

    // 1. عرض البيانات المحفوظة محلياً فوراً
    final cachedResult = await getAllVideosUseCase.callCached();
    cachedResult.fold(
      (failure) {}, 
      (videos) {
        if (!isClosed) {
          emit(VideoSuccess(videos: videos));
          hasEmittedCache = true;
        }
      }
    );

    if (!hasEmittedCache) {
      emit(VideoLoading());
    }

    // 2. جلب البيانات الحديثة في الخلفية
    final result = await getAllVideosUseCase.call();
    result.fold(
      (failure) {
        if (isClosed) return;
        if (!hasEmittedCache) {
          emit(VideoError(message: failure.errorModel.errorMessage));
        }
      },
      (videos) {
        if (isClosed) return;
        emit(VideoSuccess(videos: videos));
      }
    );
  }

}