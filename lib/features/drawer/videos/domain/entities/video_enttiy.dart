// {
// "id": 102,
// "reciter_name": "ماهر المعيقلي",
// "videos": [
// {
// "id": 15,
// "video_type": 2,
// "video_url": "https://upload.mp3quran.net/group1_pbuh/maher.mp4",
// "video_thumb_url": "https://www.mp3quran.net/uploads/videos/md/maher-2.jpeg"
// },
//
// ]

import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';

class VideoEnttiy  extends Equatable{

  final int id ;
  final String name;
  final List<SingleVideoEntity> videos;

  const VideoEnttiy({required this.id, required this.name, required this.videos});

  @override
  List<Object?> get props => [id,name,videos];

}