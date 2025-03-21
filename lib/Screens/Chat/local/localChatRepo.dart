import 'package:hive/hive.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';

class LocalChatRepository {
  final Box _box;

  LocalChatRepository(this._box);

  void saveMessages(List<ChatMessage> messages, String chatId) async {
    _box.put('chat_$chatId', messages);
  }

  List<ChatMessage> getMessages(String chatId) {
    return _box.get('chat_$chatId', defaultValue: <ChatMessage>[])
        as List<ChatMessage>;
  }
}
