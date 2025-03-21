part of 'send_message_to_story_cubit.dart';

abstract class SendMessageToStoryState {}

class SendMessageToStoryInitial extends SendMessageToStoryState {}

class SendMessageToStoryLoading extends SendMessageToStoryState {}

class SendMessageToStorySuccess extends SendMessageToStoryState {}

class SendMessageToStoryError extends SendMessageToStoryState {
  final String message;

  SendMessageToStoryError({required this.message});
}
