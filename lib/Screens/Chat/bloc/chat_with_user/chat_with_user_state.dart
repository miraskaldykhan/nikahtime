part of 'chat_with_user_bloc.dart';

abstract class ChatWithUserState extends Equatable {
  const ChatWithUserState();
}

enum PageState
{
  hold,
  preload,
  loading,
  ready,
  error,
  noMoreItem,
  newMessage
}

class ChatWithUserInitial extends ChatWithUserState {
  final PageState pageState;
  final List<ChatMessage> messages;
  final ChatWithLastMessage? chatData;

  const ChatWithUserInitial({
    this.pageState = PageState.preload,
    this.messages = const [],
    this.chatData
  });

  ChatWithUserInitial copyThis({
    PageState? pageState,
    List<ChatMessage>? messages,
    ChatWithLastMessage? chatData
  })
  {
    return ChatWithUserInitial(
        pageState : pageState ?? this.pageState,
        messages: messages ?? this.messages,
        chatData: chatData ?? this.chatData
    );
  }

  @override
  List<Object?> get props => [
    pageState,
    messages,
    chatData
  ];
}
