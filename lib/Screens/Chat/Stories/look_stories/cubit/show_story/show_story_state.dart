part of 'show_story_cubit.dart';

abstract class ShowStoryState {}

class ShowStoryInitial extends ShowStoryState {}

class ShowStoryLoading extends ShowStoryState {}

class ShowStorySuccess extends ShowStoryState {}

class ShowStoryError extends ShowStoryState {
  final String message;

  ShowStoryError({required this.message});
}
