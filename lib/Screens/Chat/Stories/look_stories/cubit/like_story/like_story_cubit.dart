import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'like_story_state.dart';

// Modify LikeStoryState to handle individual story states
class LikeStoryCubit extends Cubit<Map<int, LikeStoryState>> {
  LikeStoryCubit() : super({});

  // Access token retrieval logic
  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> likeStory({required int id}) async {
    emit({...state, id: LikeStoryLoading()}); // Обновляем состояние для конкретного ID

    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().likeStories(
        accessToken: accessToken!,
        id: id,
      );
      emit({...state, id: LikeStorySuccess()}); // Обновляем состояние на Success
    } catch (e) {
      emit({...state, id: LikeStoryError(message: e.toString())}); // Обновляем состояние на Error
    }
  }


  void resetState(int id) {
    emit(state..[id] = LikeStoryInitial());
  }
}
