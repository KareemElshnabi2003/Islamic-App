// "id": 1,
// "prophet_name": "آدم عليه السلام",
// "chapter_title": "الخليفة الأول: من طين الأرض إلى سماء الجنة ثم الهبوط العظيم",
// "image": "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=1000&auto=format&fit=crop",
// "brief": "القصة المفصلة لبداية الخلق، كيف خُلق آدم، ولماذا اعترضت الملائكة، وكيف تجبر إبليس، وصولاً إلى الخطيئة الأولى والهبوط.",
// "story":


import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final int id ;
  final String name;
  final String  storyTitle;
  final String img;
  final String brief;
  final String story;

  const StoryEntity({required this.id, required this.name, required this.storyTitle, required this.img, required this.brief, required this.story});

  @override
  List<Object?> get props =>[id,name,story,storyTitle,img,brief];

}