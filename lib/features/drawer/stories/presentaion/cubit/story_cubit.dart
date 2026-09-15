import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/stories/domain/usecases/get_story_use_case.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/cubit/story_names_state.dart';

class StoriesCubit extends Cubit<StoryNamesState> {
  final GetStoryUseCase getStoryUseCase;

  StoriesCubit({required this.getStoryUseCase}) : super(StoryNamesInitial());

  Future<void> getStories() async {
    emit(StoryNamesLoading());

    try {
      final stories = await getStoryUseCase.call();

      emit(StoryNamesSuccess(stories: stories, currentIndex: 0));
    } catch (e) {
      print('====== Error Loading Stories: $e ======');
      emit(StoryNamesError(message: "حدث خطأ أثناء تحميل القصص"));
    }
  }

  void setSelectedIndex(int index) {
    if (state is StoryNamesSuccess) {
      emit((state as StoryNamesSuccess).copyWith(currentIndex: index));
    }
  }

  void nextStory() {
    if (state is StoryNamesSuccess) {
      final currentState = state as StoryNamesSuccess;
      if (currentState.currentIndex < currentState.stories.length - 1) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex + 1));
      }
    }
  }

  void prevStory() {
    if (state is StoryNamesSuccess) {
      final currentState = state as StoryNamesSuccess;
      if (currentState.currentIndex > 0) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex - 1));
      }
    }
  }
}