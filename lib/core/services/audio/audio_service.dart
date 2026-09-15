import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// 1. Abstraction (الواجهة)
abstract class AudioService {
  Future<void> playAudioFromUrl(String url, {String title = "الصوتيات", String artist = "تطبيق إسلامي"});
  Future<void> playAudioFromAsset(String path, {String? tagId, String? title, String? artist});
  Future<void> pauseAudio();
  Future<void> stopAudio();
  Stream<PlayerState> get audioStateStream;
}

// 2. Implementation (التنفيذ)
class JustAudioServiceImpl implements AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> playAudioFromUrl(String url, {String title = "الصوتيات", String artist = "تطبيق إسلامي"}) async {
    try {
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          title: title,
          artist: artist,
        ),
      );
      await _audioPlayer.setAudioSource(audioSource);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Audio load interrupted: $e");
    }
  }

  @override
  Future<void> playAudioFromAsset(String path, {String? tagId, String? title, String? artist}) async {
    try {
      if (tagId != null) {
        final audioSource = AudioSource.asset(
          path,
          tag: MediaItem(
            id: tagId,
            title: title ?? "الصوتيات",
            artist: artist ?? "تطبيق إسلامي",
          ),
        );
        await _audioPlayer.setAudioSource(audioSource);
      } else {
        await _audioPlayer.setAsset(path);
      }
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Audio load interrupted: $e");
    }
  }

  @override
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  Stream<PlayerState> get audioStateStream => _audioPlayer.playerStateStream;
}