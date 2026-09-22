import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
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
    bool hasEmittedCache = false;

    await audioService.stopAudio();

    // 1. عرض البيانات المحفوظة محلياً فوراً
    final cachedResult = await getAyatUseCase.callCached(id: id);
    cachedResult.fold(
      (failure) {},
      (ayat) {
        if (!isClosed) {
          emit(AyatSuccess(ayat: ayat, currentSurahId: id));
          hasEmittedCache = true;
        }
      },
    );

    if (!hasEmittedCache) {
      emit(AyatLoading());
    }

    // 2. جلب البيانات الحديثة
    final result = await getAyatUseCase.call(id: id);
    result.fold(
      (failure) {
        if (isClosed) return;
        if (!hasEmittedCache) {
          emit(AyatError(message: failure.errorModel.errorMessage));
        }
      },
      (ayat) {
        if (isClosed) return;
        
        // نحافظ على حالة التشغيل والقارئ المختار لو فيه
        if (state is AyatSuccess && hasEmittedCache) {
           final currentState = state as AyatSuccess;
           emit(AyatSuccess(
             ayat: ayat, 
             currentSurahId: id,
             selectedQariIndex: currentState.selectedQariIndex,
             isPlaying: currentState.isPlaying
           ));
        } else {
           emit(AyatSuccess(ayat: ayat, currentSurahId: id));
        }
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