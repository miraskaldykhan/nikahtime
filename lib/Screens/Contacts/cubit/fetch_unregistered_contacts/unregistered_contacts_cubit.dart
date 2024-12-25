import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Contacts/models/contacts.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'unregistered_contacts_state.dart';

class UnregisteredContactsCubit extends Cubit<UnregisteredContactsState> {
  UnregisteredContactsCubit() : super(UnregisteredContactsInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getUnRegisteredContacts() async {
    emit(UnregisteredContactsLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService()
          .getNotRegisteredContacts(accessToken: accessToken!);
      if (response.isEmpty) {
        emit(UnregisteredContactsError(
            errorMessage: "Нет нерегистрированных контактов"));
      } else {
        emit(
          UnregisteredContactsSuccess(unregisteredContacts: response),
        );
      }
    } catch (e) {
      emit(
        UnregisteredContactsError(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  searchUnregisteredContacts({
    required String searchQuery,
    required List<UnRegisteredContacts> unregisteredContacts,
  }) async {
    emit(UnregisteredContactsLoading());

    emit(
      UnregisteredContactsSuccess(
        unregisteredContacts: unregisteredContacts,
        searchWord: searchQuery,
      ),
    );
  }

  backToFullContacts({
    required List<UnRegisteredContacts> unregisteredContacts,
  }) async {
    emit(UnregisteredContactsLoading());
    Future.delayed(
      Duration(
        milliseconds: 300,
      ),
    );
    emit(
      UnregisteredContactsSuccess(
        unregisteredContacts: unregisteredContacts,
      ),
    );
  }
}
