typedef ChatBlocCallback = void Function();

class ChatBlocCallbackRegistry {
  static final ChatBlocCallbackRegistry _instance = ChatBlocCallbackRegistry._internal();

  factory ChatBlocCallbackRegistry() => _instance;

  ChatBlocCallbackRegistry._internal();

  final Map<int, ChatBlocCallback> _callbacks = {};

  void register(int chatId, ChatBlocCallback callback) {
    _callbacks[chatId] = callback;
  }

  void unregister(int chatId) {
    _callbacks.remove(chatId);
  }

  void invoke(int chatId) {
    if (_callbacks.containsKey(chatId)) {
      _callbacks[chatId]!();
    }
  }

  bool isRegistered(int chatId) {
    return _callbacks.containsKey(chatId);
  }
}