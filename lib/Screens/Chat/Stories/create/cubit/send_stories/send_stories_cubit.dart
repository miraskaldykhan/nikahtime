import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'send_stories_state.dart';

class SendStoriesCubit extends Cubit<SendStoriesState> {
  SendStoriesCubit() : super(SendStoriesInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> sendStories({
    required String filePath,
    required bool isVideo,
  }) async {
    emit(SendStoriesLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().sendStories(
          filePath: filePath, accessToken: accessToken!, isVideo: isVideo);
      emit(SendStoriesSuccess());
    } catch (e) {
      emit(SendStoriesError(message: e.toString()));
    }
  }
}
