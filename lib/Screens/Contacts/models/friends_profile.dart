class FriendsProfile {
  FriendsProfile({
    required this.friends,
  });

  final Friends? friends;

  factory FriendsProfile.fromJson(Map<String, dynamic> json){
    return FriendsProfile(
      friends: json["friends"] == null ? null : Friends.fromJson(json["friends"]),
    );
  }

  @override
  String toString(){
    return "$friends, ";
  }
}

class Friends {
  Friends({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<Datum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Friends.fromJson(Map<String, dynamic> json){
    return Friends(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

  @override
  String toString(){
    return "$currentPage, $data, $firstPageUrl, $from, $lastPage, $lastPageUrl, $links, $nextPageUrl, $path, $perPage, $prevPageUrl, $to, $total, ";
  }
}

class Datum {
  Datum({
    required this.userId,
    required this.prof,
    required this.stories,
  });

  final int? userId;
  final Prof? prof;
  final List<Story> stories;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      userId: json["user_id"],
      prof: json["prof"] == null ? null : Prof.fromJson(json["prof"]),
      stories: json["stories"] == null ? [] : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
    );
  }

  @override
  String toString(){
    return "$userId, $prof, $stories, ";
  }
}

class Prof {
  Prof({
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.images,
    required this.lastActivityAt,
  });

  final String? firstName;
  final String? lastName;
  final String? photo;
  final List<Image> images;
  final DateTime? lastActivityAt;

  factory Prof.fromJson(Map<String, dynamic> json){
    return Prof(
      firstName: json["first_name"],
      lastName: json["last_name"],
      photo: json["photo"],
      images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      lastActivityAt: DateTime.tryParse(json["last_activity_at"] ?? ""),
    );
  }

  @override
  String toString(){
    return "$firstName, $lastName, $photo, $images, $lastActivityAt, ";
  }
}

class Image {
  Image({
    required this.main,
    required this.preview,
  });

  final String? main;
  final String? preview;

  factory Image.fromJson(Map<String, dynamic> json){
    return Image(
      main: json["main"],
      preview: json["preview"],
    );
  }

  @override
  String toString(){
    return "$main, $preview, ";
  }
}

class Story {
  Story({
    required this.id,
    required this.creatorId,
    required this.type,
    required this.content,
    required this.isExpired,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? creatorId;
  final String? type;
  final String? content;
  final dynamic isExpired;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Story.fromJson(Map<String, dynamic> json){
    return Story(
      id: json["id"],
      creatorId: json["creator_id"],
      type: json["type"],
      content: json["content"],
      isExpired: json["is_expired"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  @override
  String toString(){
    return "$id, $creatorId, $type, $content, $isExpired, $createdAt, $updatedAt, ";
  }
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

  @override
  String toString(){
    return "$url, $label, $active, ";
  }
}
