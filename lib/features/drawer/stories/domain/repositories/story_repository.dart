import 'package:islamic_app/features/drawer/stories/domain/entities/story_entity.dart';

abstract class StoryRepository {
  Future <List<StoryEntity>>  getStories();

}