import 'package:equatable/equatable.dart';

class VideoPlayerState extends Equatable {
  final int currentIndex;
  final bool isPlaying;
  final bool isLoading;

  const VideoPlayerState({
    this.currentIndex = 0,
    this.isPlaying = false,
    this.isLoading = true,
  });

  VideoPlayerState copyWith({
    int? currentIndex,
    bool? isPlaying,
    bool? isLoading,
  }) {
    return VideoPlayerState(
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [currentIndex, isPlaying, isLoading];
}