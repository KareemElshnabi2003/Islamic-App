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

class SingleVideoEntity extends Equatable {

  final int id;
  final String videoUrl;
  final String img;
  final int type;

  const SingleVideoEntity({required this.id, required this.videoUrl, required this.img, required this.type});

  @override
  List<Object?> get props =>[id,type,img,videoUrl];


}