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

  /// Обновляет существующее неотправленное сообщение для конкретного чата.
  static Future<void> updateUnsentMessage(
    String chatId,
    ChatMessage updatedMessage,
  ) async {
    // Загрузка всех сообщений из файла
    final allMessages = await loadAllUnsentMessages();

    // Если для этого чата нет сохранённых сообщений — ничего не делаем
    if (!allMessages.containsKey(chatId)) return;

    final messages = allMessages[chatId]!;

    // Находим индекс сообщения с таким же messageId
    final index =
        messages.indexWhere((msg) => msg.messageId == updatedMessage.messageId);

    if (index != -1) {
      // Заменяем старое сообщение на обновлённое
      messages[index] = updatedMessage;
      // Перезаписываем файл со всеми сообщениями
      await _writeAllUnsentMessages(allMessages);
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
    final messages = allMessages[chatId] ?? <ChatMessage>[];
    // 3. Находим индекс по messageId
    final index =
        messages.indexWhere((msg) => msg.messageId == message.messageId);

    if (index != -1) {
      // 4а. Если есть — обновляем
      messages[index] = message;
    } else {
      // 4б. Если нет — добавляем
      messages.add(message);
    }

    // 5. Сохраняем обратно в общий словарь и записываем в файл
    allMessages[chatId] = messages;
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
