import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/Stories/models/friends_stories.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'get_friend_stories_state.dart';

class GetFriendStoriesCubit extends Cubit<GetFriendStoriesState> {
  GetFriendStoriesCubit() : super(GetFriendStoriesInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getFriendsStories() async {
    emit(GetFriendStoriesLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response =
          await NetworkService().getFriendsStories(accessToken: accessToken!);
      if (response.data.isEmpty) {
        emit(GetFriendStoriesInitial());
      } else {
        emit(
          GetFriendStoriesSuccess(response),
        );
      }
    } catch (e) {
      emit(GetFriendStoriesError(message: e.toString()));
    }
  }
}
