import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'send_friends_request_state.dart';

class SendFriendsRequestCubit extends Cubit<SendFriendsRequestState> {
  SendFriendsRequestCubit() : super(SendFriendsRequestInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> sendRequest({
    required int userId,
  }) async {
    emit(SendFriendsRequestLoading());

    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService()
          .sendFriendsRequest(accessToken: accessToken!, userId: userId);
      emit(SendFriendsRequestSuccess());
    } catch (e) {
      emit(SendFriendsRequestError(message: e.toString()));
    }
  }

  Future<void> alreadyFriends() async {
    emit(SendFriendsRequestSuccess());
  }

  Future<void> initialize() async {
    emit(SendFriendsRequestInitial());
  }
}
