import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_audio_state.dart';
import 'package:just_audio/just_audio.dart'; // باكدج just_audio

class AdhanAudioCubit extends Cubit<AdhanAudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _slideshowTimer;

  AdhanAudioCubit() : super(AdhanAudioState());

  void playAdhan(String audioPath, void Function() onAdhanEnded) async {
    try {
      await _audioPlayer.setAsset(audioPath);
      _audioPlayer.play();
      emit(AdhanAudioState(isPlaying: true, currentImageIndex: 0));

      // ... كود التايمر بتاع الصور هنا ...

      // 👇 ده الكود اللي بيقفل الشاشة لما الصوت يخلص
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          onAdhanEnded(); // هينفذ الإغلاق
        }
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void stopAdhan() async {
    _slideshowTimer?.cancel();
    await _audioPlayer.stop();
    emit(AdhanAudioState(isPlaying: false, currentImageIndex: state.currentImageIndex));
  }

  @override
  Future<void> close() {
    // تنظيف الرامات لما الشاشة تقفل
    _slideshowTimer?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}