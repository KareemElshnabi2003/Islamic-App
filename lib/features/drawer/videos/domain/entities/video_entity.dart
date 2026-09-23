import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';

class VideoEntity extends Equatable {
  final int id;
  final String name;
  final List<SingleVideoEntity> videos;

  const VideoEntity({required this.id, required this.name, required this.videos});

  @override
  List<Object?> get props => [id, name, videos];
}