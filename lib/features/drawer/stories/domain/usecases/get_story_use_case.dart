import 'package:islamic_app/features/drawer/stories/domain/entities/story_entity.dart';
import 'package:islamic_app/features/drawer/stories/domain/repositories/story_repository.dart';

class GetStoryUseCase {

  final StoryRepository storyRepository;

  const GetStoryUseCase({required this.storyRepository});

  Future <List<StoryEntity>> call(){
    return storyRepository.getStories();
  }

}