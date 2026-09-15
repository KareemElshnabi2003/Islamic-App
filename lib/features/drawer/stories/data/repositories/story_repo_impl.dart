import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islamic_app/features/drawer/stories/data/model/story_model.dart';
import 'package:islamic_app/features/drawer/stories/domain/entities/story_entity.dart';
import 'package:islamic_app/features/drawer/stories/domain/repositories/story_repository.dart';

class StoryRepoImpl extends StoryRepository {
  @override
  Future <List<StoryEntity>> getStories()async {

    final data =await rootBundle.loadString("lib/core/assets/stories.json");
    final List<dynamic> jsonList = jsonDecode(data);
    final List<StoryModel> stories=jsonList.map((e)=>StoryModel.fromJson(e)).toList();
    return  stories;
  }






}