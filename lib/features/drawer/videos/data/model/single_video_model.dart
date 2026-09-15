
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';

class SingleVideoModel extends SingleVideoEntity {
  const SingleVideoModel({required super.id, required super.videoUrl, required super.img, required super.type});

  factory SingleVideoModel.fromJson(Map<String,dynamic> json){
    return SingleVideoModel(id: json['id'], videoUrl: json['video_url'], img: json['video_thumb_url'], type: json['video_type']);
  }


  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "video_type": type,
 "video_url": videoUrl,
 "video_thumb_url":img

    };
  }
}