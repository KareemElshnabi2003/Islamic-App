import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_enttiy.dart';

abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}
class VideoLoading extends VideoState {}

class VideoSuccess extends VideoState {
  final List<VideoEnttiy> videos;

  VideoSuccess({required this.videos});

  @override
  List<Object?> get props => [videos];
}

class VideoError extends VideoState {
  final String message;
  VideoError({required this.message});

  @override
  List<Object?> get props => [message];
}