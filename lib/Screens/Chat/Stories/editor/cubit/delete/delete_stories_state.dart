part of 'delete_stories_cubit.dart';

abstract class DeleteStoriesState {}

class DeleteStoriesInitial extends DeleteStoriesState {}

class DeleteStoriesLoading extends DeleteStoriesState {}

class DeleteStoriesSuccess extends DeleteStoriesState {}

class DeleteStoriesError extends DeleteStoriesState {
  final String message;

  DeleteStoriesError(this.message);
}
