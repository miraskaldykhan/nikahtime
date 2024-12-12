import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'show_story_state.dart';

class ShowStoryCubit extends Cubit<ShowStoryState> {
  ShowStoryCubit() : super(ShowStoryInitial());
  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> showStory({
    required int id,
  }) async {
    emit(ShowStoryLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().viewStories(
        accessToken: accessToken!,
        id: id,
      );
      emit(ShowStorySuccess());
    } catch (e) {
      emit(ShowStoryError(message: e.toString()));
    }
  }
}
