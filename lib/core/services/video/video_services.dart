import 'package:video_player/video_player.dart';

class VideoService {
  VideoPlayerController? controller;

  Future<void> initVideo(String url) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller!.initialize();
  }

  void play() => controller?.play();

  void pause() => controller?.pause();

  Future<void> dispose() async {
    await controller?.dispose();
    controller = null;
  }
}