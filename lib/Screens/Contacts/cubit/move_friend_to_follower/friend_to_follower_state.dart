part of 'friend_to_follower_cubit.dart';

abstract class FriendToFollowerState {}

class FriendToFollowerInitial extends FriendToFollowerState {}

class FriendToFollowerLoading extends FriendToFollowerState {}

class FriendToFollowerSuccess extends FriendToFollowerState {}

class FriendToFollowerError extends FriendToFollowerState {
  final String message;

  FriendToFollowerError({required this.message});
}
