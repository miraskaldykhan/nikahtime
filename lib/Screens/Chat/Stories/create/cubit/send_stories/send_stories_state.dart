part of 'send_stories_cubit.dart';

abstract class SendStoriesState {}

class SendStoriesInitial extends SendStoriesState {}

class SendStoriesLoading extends SendStoriesState {}

class SendStoriesSuccess extends SendStoriesState {}

class SendStoriesError extends SendStoriesState {
  final String message;

  SendStoriesError({required this.message});
}
