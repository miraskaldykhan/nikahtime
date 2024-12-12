class RegisteredContacts {
  RegisteredContacts({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.appName,
    required this.profilePhoto,
    required this.isInstalled,
    required this.stories,
  });

  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? appName;
  final List<ProfilePhoto> profilePhoto;
  final bool? isInstalled;
  final List<Story> stories;

  factory RegisteredContacts.fromJson(Map<String, dynamic> json){
    return RegisteredContacts(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["phone_number"],
      appName: json["app_name"],
      profilePhoto: json["profile_photo"] == null ? [] : List<ProfilePhoto>.from(json["profile_photo"]!.map((x) => ProfilePhoto.fromJson(x))),
      isInstalled: json["is_installed"],
      stories: json["stories"] == null ? [] : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
    );
  }

  @override
  String toString(){
    return "$id, $name, $phoneNumber, $appName, $profilePhoto, $isInstalled, $stories, ";
  }
}

class ProfilePhoto {
  ProfilePhoto({
    required this.main,
    required this.preview,
  });

  final String? main;
  final String? preview;

  factory ProfilePhoto.fromJson(Map<String, dynamic> json){
    return ProfilePhoto(
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

class UnRegisteredContacts {
  UnRegisteredContacts({
    required this.name,
    required this.phoneNumber,
    this.isSelected = false,
  });

  final String? name;
  final String? phoneNumber;
  bool isSelected;

  factory UnRegisteredContacts.fromJson(Map<String, dynamic> json) {
    return UnRegisteredContacts(
      name: json["name"],
      phoneNumber: json["phone_number"],
    );
  }

  @override
  String toString() {
    return "$name, $phoneNumber, ";
  }
}
