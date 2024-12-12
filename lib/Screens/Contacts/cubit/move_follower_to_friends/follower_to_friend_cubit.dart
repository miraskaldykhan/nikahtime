import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'follower_to_friend_state.dart';

class FollowerToFriendCubit extends Cubit<FollowerToFriendState> {
  FollowerToFriendCubit() : super(FollowerToFriendInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> moveFollowerToFriend({
    required int id,
  }) async {
    emit(FollowerToFriendLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().moveFollowerToFriend(
        accessToken: accessToken!,
        id: id,
      );
      emit(FollowerToFriendSuccess());
    } catch (e) {
      emit(
        FollowerToFriendError(
          message: e.toString(),
        ),
      );
    }
  }
}
