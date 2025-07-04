// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      chatId: (json['chatId'] as num?)?.toInt(),
      userAvatar: json['userAvatar'] as String?,
      userName: json['userName'] as String?,
      isChatBlocked: json['isChatBlocked'] as bool? ?? false,
      isOnline: json['isOnline'] as bool?,
      avatar: json['avatar'] == null
          ? null
          : UserProfileImage.fromJson(json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'userAvatar': instance.userAvatar,
      'userName': instance.userName,
      'isChatBlocked': instance.isChatBlocked,
      'isOnline': instance.isOnline,
      'avatar': instance.avatar,
    };

ChatWithLastMessage _$ChatWithLastMessageFromJson(Map<String, dynamic> json) =>
    ChatWithLastMessage(
      chatId: (json['chatId'] as num?)?.toInt(),
      userID: (json['userID'] as num?)?.toInt(),
      userAvatar: json['userAvatar'] as String?,
      userName: json['userName'] as String?,
      isChatBlocked: json['isChatBlocked'] as bool? ?? false,
      isOnline: json['isOnline'] as bool?,
      avatar: json['avatar'] == null
          ? null
          : UserProfileImage.fromJson(json['avatar'] as Map<String, dynamic>),
      lastTimeOnline: json['lastTimeOnline'] as String?,
      isAuthUserBlockChat: json['isAuthUserBlockChat'] as bool? ?? false,
      lastMessage: json['lastMessage'] as String?,
      lastMessageType: json['lastMessageType'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
      isAuthUserMessage: json['isAuthUserMessage'] as bool? ?? true,
      numberNotSeenMessages: (json['numberNotSeenMessages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatWithLastMessageToJson(
        ChatWithLastMessage instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'userAvatar': instance.userAvatar,
      'userName': instance.userName,
      'isChatBlocked': instance.isChatBlocked,
      'isOnline': instance.isOnline,
      'avatar': instance.avatar,
      'userID': instance.userID,
      'isAuthUserBlockChat': instance.isAuthUserBlockChat,
      'lastMessage': instance.lastMessage,
      'lastMessageType': instance.lastMessageType,
      'lastMessageTime': instance.lastMessageTime,
      'lastTimeOnline': instance.lastTimeOnline,
      'isAuthUserMessage': instance.isAuthUserMessage,
      'numberNotSeenMessages': instance.numberNotSeenMessages,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      isMessageSend: json['isMessageSend'] as bool? ?? false,
      sendedError: json['sendedError'] as bool? ?? false,
      message: json['message'] as String?,
      messageTime: json['messageTime'] as String?,
      isAuthUsermessage: json['isAuthUsermessage'] as bool?,
      messageId: (json['messageId'] as num?)?.toInt(),
      isMessageSeen: json['isMessageSeen'] as bool?,
      messageType: json['messageType'] as String?,
      edited: json['edited'] as String?,
      repliedStory: json['repliedStory'] == null
          ? null
          : Story.fromJson(json['repliedStory'] as Map<String, dynamic>),
      parent: json['parent'] == null
          ? null
          : ChatMessage.fromJson(json['parent'] as Map<String, dynamic>),
      uploadProgress: (json['uploadProgress'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'isMessageSend': instance.isMessageSend,
      'sendedError': instance.sendedError,
      'message': instance.message,
      'messageTime': instance.messageTime,
      'isAuthUsermessage': instance.isAuthUsermessage,
      'messageId': instance.messageId,
      'isMessageSeen': instance.isMessageSeen,
      'messageType': instance.messageType,
      'parent': instance.parent,
      'edited': instance.edited,
      'repliedStory': instance.repliedStory,
      'uploadProgress': instance.uploadProgress,
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
