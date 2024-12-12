part of 'send_friends_request_cubit.dart';

abstract class SendFriendsRequestState {}

class SendFriendsRequestInitial extends SendFriendsRequestState {}

class SendFriendsRequestLoading extends SendFriendsRequestState {}

class SendFriendsRequestSuccess extends SendFriendsRequestState {}

class SendFriendsRequestError extends SendFriendsRequestState {
  final String message;

  SendFriendsRequestError({required this.message});
}
