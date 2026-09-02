import 'package:islamic_app/features/drawer/videos/data/model/single_video_model.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_enttiy.dart';

class VideoModel extends VideoEnttiy {
  const VideoModel({required super.id,  required super.name, required super.videos});

  factory VideoModel.fromJson(Map<String,dynamic> json){
    return VideoModel(
        id: json['id'],
        videos: json['videos'] != null
            ? (json['videos'] as List).map((e) => SingleVideoModel.fromJson(e)).toList()
            : [],
        name: json['reciter_name']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "videos":  videos.map((e) => (e as SingleVideoModel).toJson()).toList(),
      "reciter_name": name,
    };
  }
}