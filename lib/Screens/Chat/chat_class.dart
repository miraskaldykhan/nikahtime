import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/components/models/user_profile_data.dart';

part 'chat_class.g.dart';

@JsonSerializable()
class Chat {
  int? chatId;
  String? userAvatar;
  String? userName;
  bool isChatBlocked = false;
  bool? isOnline;
  UserProfileImage? avatar;

  Chat(
      {this.chatId,
      this.userAvatar,
      this.userName,
      this.isChatBlocked = false,
      this.isOnline,
      this.avatar});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@JsonSerializable()
class ChatWithLastMessage extends Chat {
  int? userID;
  bool isAuthUserBlockChat = false;
  String? lastMessage;
  String? lastMessageType;
  String? lastMessageTime;
  String? lastTimeOnline;
  bool isAuthUserMessage = true;
  int? numberNotSeenMessages;

  ChatWithLastMessage({
    int? chatId,
    this.userID,
    String? userAvatar,
    String? userName,
    bool isChatBlocked = false,
    bool? isOnline,
    UserProfileImage? avatar,
    this.lastTimeOnline,
    this.isAuthUserBlockChat = false,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.isAuthUserMessage = true,
    this.numberNotSeenMessages,
  }) : super(
            chatId: chatId,
            userAvatar: userAvatar,
            userName: userName,
            isChatBlocked: isChatBlocked,
            avatar: avatar);

  ChatWithLastMessage copyThis(
      {int? chatID,
      int? userID,
      String? userAvatar,
      String? userName,
      bool? isChatBlocked,
      bool? isAuthUserBlockChat,
      bool? isOnline,
      String? lastMessage,
      String? lastMessageType,
      String? lastMessageTime,
      String? lastTimeOnline,
      bool? isAuthUserMessage,
      int? numberNotSeenMessages,
      UserProfileImage? avatar}) {
    return ChatWithLastMessage(
        chatId: chatID ?? this.chatId,
        userID: userID ?? this.userID,
        userAvatar: userAvatar ?? this.userAvatar,
        userName: userName ?? this.userName,
        isChatBlocked: isChatBlocked ?? this.isChatBlocked,
        isOnline: isOnline ?? this.isOnline,
        isAuthUserBlockChat: isAuthUserBlockChat ?? this.isAuthUserBlockChat,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageType: lastMessageType ?? this.lastMessageType,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        lastTimeOnline: lastTimeOnline ?? this.lastTimeOnline,
        isAuthUserMessage: isAuthUserMessage ?? this.isAuthUserMessage,
        numberNotSeenMessages:
            numberNotSeenMessages ?? this.numberNotSeenMessages,
        avatar: avatar ?? this.avatar);
  }

  factory ChatWithLastMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatWithLastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatWithLastMessageToJson(this);

  GetDataFromJson(Map<dynamic, dynamic> json) {
    chatId = json["chatId"];
    userID = json["userID"];
    userAvatar = json["userAvatar"];
    userName = json["userName"];
    isChatBlocked = json["isChatBlocked"];
    isAuthUserBlockChat = json["isAuthUserBlockChat"];
    lastMessage = json["lastMessage"];
    lastMessageType = json["lastMessageType"];
    lastMessageTime = json["lastMessageTime"];
    lastTimeOnline = json["lastTimeOnline"];
    isAuthUserMessage = json["isAuthUserMessage"];
    numberNotSeenMessages = json["numberNotSeenMessages"];
    isOnline = json["isOnline"];
    avatar = UserProfileImage.fromJson(json["avatar"]);
  }

  @override
  String toString() {
    return 'ChatWithLastMessage{userID: $userID, isAuthUserBlockChat: $isAuthUserBlockChat, lastMessage: $lastMessage, lastMessageType: $lastMessageType, lastMessageTime: $lastMessageTime, lastTimeOnline: $lastTimeOnline, isAuthUserMessage: $isAuthUserMessage, numberNotSeenMessages: $numberNotSeenMessages}';
  }
}

@JsonSerializable()
class ChatMessage {
  bool isMessageSend = false;
  bool sendedError = false;
  String? message;
  String? messageTime;
  bool? isAuthUsermessage;
  int? messageId;
  bool? isMessageSeen;
  String? messageType;
  String? edited;
  Story? repliedStory;

  ChatMessage({
    this.isMessageSend = false,
    this.sendedError = false,
    this.message,
    this.messageTime,
    this.isAuthUsermessage,
    this.messageId,
    this.isMessageSeen,
    this.messageType,
    this.edited,
    this.repliedStory,
  });

  ChatMessage copyWith({
    String? message,
    bool isMessageSend = false,
    bool sendedError = false,
    String? messageTime,
    bool? isAuthUserMessage,
    String? messageType,
    int? messageId,
    bool? isMessageSeen,
    String? edited,
    Story? repliedStory,
  }) {
    return ChatMessage(
      isMessageSend: isMessageSend,
      sendedError: sendedError,
      message: message ?? this.message,
      messageTime: messageTime ?? this.messageTime,
      isAuthUsermessage: isAuthUserMessage ?? this.isAuthUsermessage,
      messageType: messageType ?? this.messageType,
      messageId: messageId ?? this.messageId,
      isMessageSeen: isMessageSeen ?? this.isMessageSeen,
      edited: edited ?? this.edited,
      repliedStory: repliedStory ?? this.repliedStory,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  GetDataFromJson(Map<dynamic, dynamic> json) {
    message = json["message"];
    messageTime = json["messageTime"];
    isAuthUsermessage = json["isAuthUserMessage"];
    messageId = json["messageId"];
    isMessageSeen = json["isMessageSeen"];
    messageType = json["messageType"];
    edited = json['edited'];
    repliedStory = json['repliedStory'] != null
        ? Story.fromJson(json['repliedStory'])
        : null;
  }

  @override
  String toString() {
    return 'ChatMessage{isMessageSend: $isMessageSend, sendedError: $sendedError, message: $message, messageTime: $messageTime, isAuthUsermessage: $isAuthUsermessage, messageId: $messageId, isMessageSeen: $isMessageSeen, messageType: $messageType, edited: $edited, repliedStory: $repliedStory}';
  }
}

@JsonSerializable()
class Story {
  Story({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  final int? id;
  final String? type;
  final String? content;
  final DateTime? createdAt;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
