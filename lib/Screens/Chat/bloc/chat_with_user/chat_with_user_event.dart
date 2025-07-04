part of 'chat_with_user_bloc.dart';

abstract class ChatWithUserEvent extends Equatable {
  const ChatWithUserEvent();
}

class LoadChatData extends ChatWithUserEvent {
  final int chatId;

  const LoadChatData({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class NewMessage extends ChatWithUserEvent {
  final int messageId;

  const NewMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class ReadMessage extends ChatWithUserEvent {
  const ReadMessage();

  @override
  List<Object?> get props => [];
}

class BlockChat extends ChatWithUserEvent {
  const BlockChat();

  @override
  List<Object?> get props => [];
}

class SendTextMessage extends ChatWithUserEvent {
  final String text;
  final int chatId;
  final int? parentMessageId;

  const SendTextMessage(
      {required this.text, required this.chatId, this.parentMessageId});

  @override
  List<Object?> get props => [
        text,
        chatId,
      ];
}

class SendFile extends ChatWithUserEvent {
  final File file;
  final String fileType;
  final int? parentMessageId;

  const SendFile(
      {required this.file, required this.fileType, this.parentMessageId});

  @override
  List<Object?> get props => [file, fileType];
}

class AnswerChat extends ChatWithUserEvent {
  final String answerText;
  final int answerMessageId;

  const AnswerChat({
    required this.answerText,
    required this.answerMessageId,
  });

  @override
  List<Object?> get props => [answerText];
}

class EditChat extends ChatWithUserEvent {
  final String editText;
  final int messageId;

  const EditChat({
    required this.editText,
    required this.messageId,
  });

  @override
  List<Object?> get props => [editText];
}

class EditChatActive extends ChatWithUserEvent {
  final int messageId;
  final String editText;

  const EditChatActive({
    required this.messageId,
    required this.editText,
  });

  @override
  List<Object?> get props => [messageId];
}

class RemoveAnswerChat extends ChatWithUserEvent {
  const RemoveAnswerChat();

  @override
  List<Object?> get props => [];
}

class RetrySendSingleMessage extends ChatWithUserEvent {
  final int messageId; // идентификатор сообщения

  const RetrySendSingleMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class RetrySendAllUnsentMessages extends ChatWithUserEvent {
  const RetrySendAllUnsentMessages();

  @override
  List<Object?> get props => [];
}

class DeleteChatMessageWithId extends ChatWithUserEvent {
  final int messageId; // идентификатор сообщения

  const DeleteChatMessageWithId({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class UpdateUploadProgress extends ChatWithUserEvent {
  final int messageId;
  final double progress;

  const UpdateUploadProgress({required this.messageId, required this.progress});

  @override
  List<Object?> get props => [messageId, progress];
}
