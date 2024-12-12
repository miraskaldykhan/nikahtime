import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'friend_to_follower_state.dart';

class FriendToFollowerCubit extends Cubit<FriendToFollowerState> {
  FriendToFollowerCubit() : super(FriendToFollowerInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> moveFriendToFollower({
    required int id,
  }) async {
    emit(FriendToFollowerLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().moveFriendToFollower(
        accessToken: accessToken!,
        userId: id,
      );
      emit(FriendToFollowerSuccess());
    } catch (e) {
      emit(
        FriendToFollowerError(
          message: e.toString(),
        ),
      );
    }
  }
}
