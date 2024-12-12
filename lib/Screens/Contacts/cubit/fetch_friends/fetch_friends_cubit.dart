import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Contacts/models/friends_profile.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'fetch_friends_state.dart';

class FetchFriendsCubit extends Cubit<FetchFriendsState> {
  FetchFriendsCubit() : super(FetchFriendsInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getFriendsList() async {
    emit(FetchFriendsLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response =
          await NetworkService().getMineFriends(accessToken: accessToken!);
      if (response.friends!.data.isNotEmpty) {
        emit(FetchFriendsSuccess(friendsProfile: response));
      } else {
        emit(
          FetchFriendsError(message: "No one"),
        );
      }
    } catch (e) {
      emit(FetchFriendsError(message: e.toString()));
    }
  }

  searchRegisteredContacts({
    required String searchQuery,
    required FriendsProfile friendsProfile,
  }) async {
    emit(FetchFriendsLoading());

    emit(
      FetchFriendsSuccess(
        friendsProfile: friendsProfile,
        searchWord: searchQuery,
      ),
    );
  }

  backToFullContacts({
    required FriendsProfile friendsProfile,
  }) async {
    emit(FetchFriendsLoading());
    Future.delayed(
      Duration(
        milliseconds: 300,
      ),
    );
    emit(
      FetchFriendsSuccess(friendsProfile: friendsProfile),
    );
  }
}
