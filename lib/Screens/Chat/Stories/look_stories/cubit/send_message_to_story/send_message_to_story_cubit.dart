import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../ServiceItems/network_service.dart';

part 'send_message_to_story_state.dart';

class SendMessageToStoryCubit extends Cubit<SendMessageToStoryState> {
  SendMessageToStoryCubit() : super(SendMessageToStoryInitial());

  Future<void> sendMessageToStory({
    required int storyId,
    required userId,
    required String message,
  }) async {
    emit(SendMessageToStoryLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";

    try {
      var response = await NetworkService().ChatsAddUserID(accessToken, userId);
      log("Попытка создания нового чата ${response.statusCode}");
      log("Результат ${response.body}");

      if (response.statusCode != 200) {
        emit(SendMessageToStoryError(message: "Error on send"));
      }
      int chatID = jsonDecode(response.body)["chatId"];

      var responseForMessage = await NetworkService().ChatsSendMessage(
        accessToken,
        message,
        chatID,
        "text",
        repliedStoryId: storyId,
      );
      emit(SendMessageToStorySuccess());
    } catch (e) {
      emit(SendMessageToStoryError(message: "Error on send: ${e.toString()}"));
    }
  }
}
