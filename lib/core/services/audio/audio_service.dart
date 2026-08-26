import 'package:just_audio/just_audio.dart';

// 1. Abstraction (الواجهة)
abstract class AudioService {
  Future<void> playAudioFromUrl(String url);
  Future<void> playAudioFromAsset(String path);
  Future<void> pauseAudio();
  Future<void> stopAudio();
  Stream<PlayerState> get audioStateStream;
}

// 2. Implementation (التنفيذ)
class JustAudioServiceImpl implements AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> playAudioFromUrl(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  @override
  Future<void> playAudioFromAsset(String path) async {
    await _audioPlayer.setAsset(path);
    _audioPlayer.play();
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