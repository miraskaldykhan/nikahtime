import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Contacts/models/followers_profile.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'fetch_followers_state.dart';

class FetchFollowersCubit extends Cubit<FetchFollowersState> {
  FetchFollowersCubit() : super(FetchFollowersInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getFollowersList() async {
    emit(FetchFollowersLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response =
          await NetworkService().getMineFollowers(accessToken: accessToken!);
      if (response.followers!.data.isNotEmpty) {
        emit(
          FetchFollowersSuccess(followersProfiles: response),
        );
      } else {
        emit(FetchFollowersError(message: "No one"));
      }
    } catch (e) {
      emit(FetchFollowersError(message: e.toString()));
    }
  }
}
