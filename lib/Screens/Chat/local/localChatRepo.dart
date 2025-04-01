import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';

class LocalMessageStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/unsent_messages.json');
  }

  // Загружает все неотправленные сообщения, организованные по чатам
  static Future<Map<String, List<ChatMessage>>> loadAllUnsentMessages() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        return {};
      }
      final contents = await file.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(contents);
      Map<String, List<ChatMessage>> result = {};
      jsonData.forEach((chatId, messagesJson) {
        result[chatId] = (messagesJson as List)
            .map((msgJson) => ChatMessage.fromJson(msgJson))
            .toList();
      });
      return result;
    } catch (e) {
      print("Ошибка загрузки сообщений: $e");
      return {};
    }
  }

  // Перезаписывает файл с неотправленными сообщениями для всех чатов
  static Future<void> _writeAllUnsentMessages(
      Map<String, List<ChatMessage>> messagesMap) async {
    final file = await _localFile;
    Map<String, dynamic> jsonData = {};
    messagesMap.forEach((chatId, messages) {
      jsonData[chatId] = messages.map((m) => m.toJson()).toList();
    });
    await file.writeAsString(jsonEncode(jsonData));
  }

  /// Сохраняет неотправленное сообщение для конкретного чата.
  static Future<void> saveUnsentMessage(
      String chatId, ChatMessage message) async {
    Map<String, List<ChatMessage>> allMessages = await loadAllUnsentMessages();
    if (allMessages.containsKey(chatId)) {
      allMessages[chatId]!.add(message);
    } else {
      allMessages[chatId] = [message];
    }
    await _writeAllUnsentMessages(allMessages);
  }

  /// Загружает неотправленные сообщения для конкретного чата.
  static Future<List<ChatMessage>> loadUnsentMessagesForChat(
      String chatId) async {
    Map<String, List<ChatMessage>> allMessages = await loadAllUnsentMessages();
    return allMessages[chatId] ?? [];
  }

  /// Удаляет конкретное неотправленное сообщение по его идентификатору для чата.
  static Future<void> removeUnsentMessage(
      String chatId, dynamic messageId) async {
    Map<String, List<ChatMessage>> allMessages = await loadAllUnsentMessages();
    if (allMessages.containsKey(chatId)) {
      allMessages[chatId]!.removeWhere((msg) => msg.messageId == messageId);
      await _writeAllUnsentMessages(allMessages);
    }
  }

  /// Очищает все неотправленные сообщения для конкретного чата.
  static Future<void> clearUnsentMessagesForChat(String chatId) async {
    Map<String, List<ChatMessage>> allMessages = await loadAllUnsentMessages();
    if (allMessages.containsKey(chatId)) {
      allMessages.remove(chatId);
      await _writeAllUnsentMessages(allMessages);
    }
  }
}
