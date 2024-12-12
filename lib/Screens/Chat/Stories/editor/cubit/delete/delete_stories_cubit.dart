import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'delete_stories_state.dart';

class DeleteStoriesCubit extends Cubit<DeleteStoriesState> {
  DeleteStoriesCubit() : super(DeleteStoriesInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> deleteStories({
    required int id,
  }) async {
    emit(DeleteStoriesLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService()
          .deleteStories(accessToken: accessToken!, id: id);
      emit(DeleteStoriesSuccess());
    } catch (e) {
      emit(DeleteStoriesError(e.toString()));
    }
  }
}
