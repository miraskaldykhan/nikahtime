part of 'fetch_registered_contacts_cubit.dart';

abstract class FetchRegisteredContactsState {}

class FetchRegisteredContactsInitial extends FetchRegisteredContactsState {}

class FetchRegisteredContactsLoading extends FetchRegisteredContactsState {}

class FetchRegisteredContactsSuccess extends FetchRegisteredContactsState {
  final List<RegisteredContacts> registeredContacts;
  final String? searchWord;

  FetchRegisteredContactsSuccess(
      {required this.registeredContacts, this.searchWord});
}

class FetchRegisteredContactsError extends FetchRegisteredContactsState {
  final String message;

  FetchRegisteredContactsError({required this.message});
}
