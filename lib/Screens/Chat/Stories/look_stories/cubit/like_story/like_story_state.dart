part of 'like_story_cubit.dart';

abstract class LikeStoryState {}

class LikeStoryInitial extends LikeStoryState {}

class LikeStoryLoading extends LikeStoryState {}

class LikeStorySuccess extends LikeStoryState {}

class LikeStoryError extends LikeStoryState {
  final String message;

  LikeStoryError({
    required this.message,
  });
}
