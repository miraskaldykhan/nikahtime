class FriendsStories {
  FriendsStories({
    required this.data,
  });

  final List<Datum> data;

  factory FriendsStories.fromJson(Map<String, dynamic> json) {
    return FriendsStories(
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$data, ";
  }
}

class Datum {
  Datum({
    required this.usersId,
    required this.usersFirstName,
    required this.usersLastName,
    required this.userProfileUrl,
    required this.stories,
  });

  final int? usersId;
  final String? usersFirstName;
  final String? usersLastName;
  final List<String> userProfileUrl;
  final List<Story> stories;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      usersId: json["users_id"],
      usersFirstName: json["users_first_name"],
      usersLastName: json["users_last_name"],
      userProfileUrl: json["user_profile_url"] == null
          ? []
          : List<String>.from(json["user_profile_url"]!.map((x) => x)),
      stories: json["stories"] == null
          ? []
          : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$usersId, $usersFirstName, $usersLastName, $userProfileUrl, $stories, ";
  }
}

class Story {
  Story({
    required this.id,
    required this.type,
    required this.content,
    required this.isLiked,
    required this.isViewed,
    required this.createdAt,
  });

  final int? id;
  final String? type;
  final String? content;
  final bool? isLiked;
  final bool? isViewed;
  final DateTime? createdAt;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["id"],
      type: json["type"],
      content: json["content"],
      isLiked: json["is_liked"],
      isViewed: json["is_viewed"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  @override
  String toString() {
    return "$id, $type, $content, $isLiked, $isViewed, $createdAt, ";
  }
}
