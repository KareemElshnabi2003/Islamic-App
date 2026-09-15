import 'package:islamic_app/features/drawer/stories/domain/entities/story_entity.dart';

class StoryModel  extends StoryEntity{
 const StoryModel({required super.id, required super.name, required super.storyTitle, required super.img, required super.brief, required super.story});

factory StoryModel.fromJson(Map<String,dynamic> json){
  return StoryModel(id: json['id'], name: json['prophet_name'], storyTitle: json['chapter_title'], img: json['image'], brief: json['brief'], story: json['story']);
}

Map<String,dynamic> toJson(){
  return {
    "id":id,
    "prophet_name": name,
    "chapter_title": storyTitle,
    "image": img,
    "brief":brief,
    "story":story
  };
}

}

