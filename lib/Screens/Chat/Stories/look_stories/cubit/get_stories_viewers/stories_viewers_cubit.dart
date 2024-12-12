import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/Stories/models/viewers_model.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'stories_viewers_state.dart';

class StoriesViewersCubit extends Cubit<StoriesViewersState> {
  StoriesViewersCubit() : super(StoriesViewersInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getStoriesViewers({
    required int id,
  }) async {
    emit(StoriesViewersLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService().getStoriesViewers(
        accessToken: accessToken!,
        id: id,
      );
      if (response.viewers.isNotEmpty) {
        emit(StoriesViewersSuccess(response));
      } else {
        emit(StoriesViewersInitial());
      }
    } catch (e) {
      emit(StoriesViewersError(message: e.toString()));
    }
  }
}
