part of 'fetch_followers_cubit.dart';

abstract class FetchFollowersState {}

class FetchFollowersInitial extends FetchFollowersState {}

class FetchFollowersLoading extends FetchFollowersState {}

class FetchFollowersSuccess extends FetchFollowersState {
  final FollowersProfiles followersProfiles;

  FetchFollowersSuccess({required this.followersProfiles});
}

class FetchFollowersError extends FetchFollowersState {
  final String message;

  FetchFollowersError({required this.message});
}
