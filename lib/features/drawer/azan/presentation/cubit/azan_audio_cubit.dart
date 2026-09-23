import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/features/drawer/azan/presentation/cubit/azan_audio_state.dart';
import 'package:just_audio/just_audio.dart';

class AdhanAudioCubit extends Cubit<AdhanAudioState> {
  final AudioService _audioService;
  Timer? _slideshowTimer;

  AdhanAudioCubit(this._audioService) : super(AdhanAudioState());

  void playAdhan(String audioPath, void Function() onAdhanEnded) async {
    try {
      await _audioService.playAudioFromAsset(
        audioPath,
        tagId: 'adhan_audio',
        title: 'الأذان',
        artist: 'تطبيق إسلامي',
      );
      emit(AdhanAudioState(isPlaying: true, currentImageIndex: 0));

      _audioService.audioStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          onAdhanEnded();
        }
      });
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void stopAdhan() async {
    _slideshowTimer?.cancel();
    await _audioService.stopAudio();
    emit(AdhanAudioState(isPlaying: false, currentImageIndex: state.currentImageIndex));
  }

  @override
  Future<void> close() {
    _slideshowTimer?.cancel();
    return super.close();
  }
}