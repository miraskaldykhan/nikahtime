part of 'unregistered_contacts_cubit.dart';

abstract class UnregisteredContactsState {}

class UnregisteredContactsInitial extends UnregisteredContactsState {}

class UnregisteredContactsLoading extends UnregisteredContactsState {}

class UnregisteredContactsSuccess extends UnregisteredContactsState {
  final List<UnRegisteredContacts> unregisteredContacts;
  final String? searchWord;

  UnregisteredContactsSuccess({
    required this.unregisteredContacts,
    this.searchWord,
  });
}

class UnregisteredContactsError extends UnregisteredContactsState {
  final String errorMessage;

  UnregisteredContactsError({required this.errorMessage});
}
