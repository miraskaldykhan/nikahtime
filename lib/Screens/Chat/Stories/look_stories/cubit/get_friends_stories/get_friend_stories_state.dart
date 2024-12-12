part of 'get_friend_stories_cubit.dart';

abstract class GetFriendStoriesState {}

class GetFriendStoriesInitial extends GetFriendStoriesState {}

class GetFriendStoriesLoading extends GetFriendStoriesState {}

class GetFriendStoriesSuccess extends GetFriendStoriesState {
  final FriendsStories friendsStories;

  GetFriendStoriesSuccess(this.friendsStories);
}

class GetFriendStoriesError extends GetFriendStoriesState {
  final String message;

  GetFriendStoriesError({required this.message});
}
