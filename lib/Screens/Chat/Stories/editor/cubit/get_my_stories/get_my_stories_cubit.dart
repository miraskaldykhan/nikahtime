import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/Stories/models/stories_model.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'get_my_stories_state.dart';

class GetMyStoriesCubit extends Cubit<GetMyStoriesState> {
  GetMyStoriesCubit() : super(GetMyStoriesInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getMyStories() async {
    emit(GetMyStoriesLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response =
          await NetworkService().getMyStories(accessToken: accessToken!);
      emit(
        GetMyStoriesSuccess(model: response),
      );
    } catch (e) {
      emit(GetMyStoriesError(message: e.toString()));
    }
  }
}
