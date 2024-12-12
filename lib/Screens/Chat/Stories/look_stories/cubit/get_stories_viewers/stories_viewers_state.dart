part of 'stories_viewers_cubit.dart';

abstract class StoriesViewersState {}

class StoriesViewersInitial extends StoriesViewersState {}

class StoriesViewersLoading extends StoriesViewersState {}

class StoriesViewersSuccess extends StoriesViewersState {
  final ViewersOfStories viewersOfStories;

  StoriesViewersSuccess(this.viewersOfStories);
}

class StoriesViewersError extends StoriesViewersState {
  final String message;

  StoriesViewersError({
    required this.message,
  });
}
