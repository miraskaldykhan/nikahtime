part of 'follower_to_friend_cubit.dart';

abstract class FollowerToFriendState {}

class FollowerToFriendInitial extends FollowerToFriendState {}

class FollowerToFriendLoading extends FollowerToFriendState {}

class FollowerToFriendSuccess extends FollowerToFriendState {}

class FollowerToFriendError extends FollowerToFriendState {
  final String message;

  FollowerToFriendError({required this.message});
}
