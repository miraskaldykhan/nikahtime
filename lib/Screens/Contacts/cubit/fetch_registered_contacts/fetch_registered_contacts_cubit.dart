import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Contacts/models/contacts.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/generated/locale_keys.g.dart';

part 'fetch_registered_contacts_state.dart';

class FetchRegisteredContactsCubit extends Cubit<FetchRegisteredContactsState> {
  FetchRegisteredContactsCubit() : super(FetchRegisteredContactsInitial());

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  Future<void> getRegisteredContacts() async {
    emit(FetchRegisteredContactsLoading());
    if (accessToken == null) {
      await getAccessToken();
    }
    try {
      var response = await NetworkService()
          .getRegisteredContacts(accessToken: accessToken!);
      if (response.isEmpty) {
        emit(FetchRegisteredContactsError(
            message: LocaleKeys.contactNotRegistered.tr()));
      } else {
        emit(
          FetchRegisteredContactsSuccess(registeredContacts: response),
        );
      }
    } catch (e) {
      emit(FetchRegisteredContactsError(message: e.toString()));
    }
  }

  searchRegisteredContacts({
    required String searchQuery,
    required List<RegisteredContacts> registeredContacts,
  }) async {
    emit(FetchRegisteredContactsLoading());

    emit(FetchRegisteredContactsSuccess(
      registeredContacts: registeredContacts,
      searchWord: searchQuery,
    ));
  }

  backToFullContacts({
    required List<RegisteredContacts> registeredContacts,
  }) async {
    emit(FetchRegisteredContactsLoading());
    Future.delayed(Duration(milliseconds: 300));
    emit(
        FetchRegisteredContactsSuccess(registeredContacts: registeredContacts));
  }
}
