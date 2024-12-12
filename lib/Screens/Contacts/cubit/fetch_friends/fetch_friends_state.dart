part of 'fetch_friends_cubit.dart';

abstract class FetchFriendsState {}

class FetchFriendsInitial extends FetchFriendsState {}

class FetchFriendsLoading extends FetchFriendsState {}

class FetchFriendsSuccess extends FetchFriendsState {
  final FriendsProfile friendsProfile;
  final String? searchWord;

  FetchFriendsSuccess({required this.friendsProfile, this.searchWord});
}

class FetchFriendsError extends FetchFriendsState {
  final String message;

  FetchFriendsError({required this.message});
}
