import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/stories/domain/entities/story_entity.dart';

abstract class StoryNamesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoryNamesInitial extends StoryNamesState {}

class StoryNamesLoading extends StoryNamesState {}

class StoryNamesSuccess extends StoryNamesState {
  final List<StoryEntity> stories;
  final int currentIndex;

  StoryNamesSuccess({
    required this.stories,
    this.currentIndex = 0,
  });

  StoryNamesSuccess copyWith({
    List<StoryEntity>? stories,
    int? currentIndex,
  }) {
    return StoryNamesSuccess(
      stories: stories ?? this.stories,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [stories, currentIndex];
}

class StoryNamesError extends StoryNamesState {
  final String message;
  StoryNamesError({required this.message});

  @override
  List<Object?> get props => [message];
}