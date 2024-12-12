part of 'get_my_stories_cubit.dart';

abstract class GetMyStoriesState {}

class GetMyStoriesInitial extends GetMyStoriesState {}

class GetMyStoriesLoading extends GetMyStoriesState {}

class GetMyStoriesSuccess extends GetMyStoriesState {
  final MyStoryResponse model;

  GetMyStoriesSuccess({required this.model});
}

class GetMyStoriesError extends GetMyStoriesState {
  final String message;

  GetMyStoriesError({required this.message});
}
