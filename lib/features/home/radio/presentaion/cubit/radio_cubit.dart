import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/features/home/radio/data/repositories/radio_repo_impl.dart';
import 'package:islamic_app/features/home/radio/domain/usecases/get_radio_urls_use_case.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  final GetRadioUrlsUseCase getRadioUrlsUseCase;
  final AudioService audioService;
  RadioCubit( {required this.getRadioUrlsUseCase, required this.audioService}):super(RadioInitial());

  Future <void>getRadios()async{
    emit(RadioLoading());

    final result=await getRadioUrlsUseCase.call();
    result.fold(
          (failure) {
        emit(RadioError(message: failure.errorModel.errorMessage));
      },
          (radios) {
        emit(RadioSuccess(radios: radios));
      },
    );
  }

  Future<void> togglePlay() async {
    if (state is RadioSuccess) {
      final currentState = state as RadioSuccess;

      if (currentState.isPlaying) {
        emit(currentState.copyWith(isPlaying: false));
        await audioService.stopAudio();
      } else {
        emit(currentState.copyWith(isPlaying: true));
        await audioService.playAudioFromUrl(currentState.radios[currentState.currentIndex].url);
      }
    }
  }
// الإذاعة التالية
  Future<void> nextRadio() async {
    if (state is RadioSuccess) {
      final currentState = state as RadioSuccess;

      if (currentState.currentIndex < currentState.radios.length - 1) {
        final newIndex = currentState.currentIndex + 1;
        emit(currentState.copyWith(currentIndex: newIndex));

        if (currentState.isPlaying) {
          await audioService.playAudioFromUrl(currentState.radios[newIndex].url);
        }
      }
    }
  }

  Future<void> previousRadio() async {
    if (state is RadioSuccess) {
      final currentState = state as RadioSuccess;

      if (currentState.currentIndex > 0) {
        final newIndex = currentState.currentIndex - 1;
        emit(currentState.copyWith(currentIndex: newIndex));

        if (currentState.isPlaying) {
          await audioService.playAudioFromUrl(currentState.radios[newIndex].url);
        }
      }
    }
  }
}