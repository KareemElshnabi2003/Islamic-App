import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_ayat_use_case.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_state.dart';


// ================= Cubit =================
class AyatCubit extends Cubit<AyatState> {
  final GetAyatUseCase getAyatUseCase;
  final AudioService audioService;

  AyatCubit({required this.getAyatUseCase, required this.audioService}) : super(AyatInitial());

  int currentId = 1;

  Future<void> getAyat({required int id}) async {
    currentId = id;
    emit(AyatLoading());

    await audioService.stopAudio();

    final result = await getAyatUseCase.call(id: id);
    result.fold(
          (failure) {
            if (isClosed) return; // السطر ده للحماية

            emit(AyatError(message: failure.errorModel.errorMessage));
          },
          (ayat) {
            if (isClosed) return; // السطر ده للحماية

            emit(AyatSuccess(ayat: ayat, currentSurahId: id));
          },
    );
  }

  void nextSoura() {
    if (currentId < 114) { // القرآن 114 سورة
      getAyat(id: currentId + 1);
    }
  }

  void prevSoura() {
    if (currentId > 1) {
      getAyat(id: currentId - 1);
    }
  }

  Future<void> togglePlay() async {
    if (state is AyatSuccess) {
      final currentState = state as AyatSuccess;

      if (currentState.isPlaying) {
        emit(currentState.copyWith(isPlaying: false));
        await audioService.stopAudio();
      } else {
        emit(currentState.copyWith(isPlaying: true));
        final audioUrl = currentState.ayat.audio[currentState.selectedQariIndex].audioUrl;
        await audioService.playAudioFromUrl(audioUrl);
      }
    }
  }

  Future<void> changeQari(int index) async {
    if (state is AyatSuccess) {
      final currentState = state as AyatSuccess;
      emit(currentState.copyWith(selectedQariIndex: index, isPlaying: false));
      await audioService.stopAudio();
    }
  }

  @override
  Future<void> close() {
    audioService.stopAudio();
    return super.close();
  }
}