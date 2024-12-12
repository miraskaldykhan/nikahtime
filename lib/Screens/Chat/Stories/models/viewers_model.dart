class ViewersOfStories {
  ViewersOfStories({
    required this.viewers,
  });

  final List<Viewer> viewers;

  factory ViewersOfStories.fromJson(Map<String, dynamic> json) {
    return ViewersOfStories(
      viewers: json["viewers"] == null
          ? []
          : List<Viewer>.from(json["viewers"]!.map((x) => Viewer.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$viewers, ";
  }
}

class Viewer {
  Viewer({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.avatar,
    required this.viewQuantity,
    required this.lastView,
    required this.isLiked,
  });

  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final List<Avatar> avatar;
  final int? viewQuantity;
  final DateTime? lastView;
  final bool? isLiked;

  factory Viewer.fromJson(Map<String, dynamic> json) {
    return Viewer(
      id: json["id"],
      name: json["name"],
      surname: json["surname"],
      email: json["email"],
      avatar: json["avatar"] == null
          ? []
          : List<Avatar>.from(json["avatar"]!.map((x) => Avatar.fromJson(x))),
      viewQuantity: json["view_quantity"],
      lastView: DateTime.tryParse(json["last_view"] ?? ""),
      isLiked: json["is_liked"],
    );
  }

  @override
  String toString() {
    return "$id, $name, $surname, $email, $avatar, $viewQuantity, $lastView, $isLiked, ";
  }
}

class Avatar {
  Avatar({
    required this.main,
    required this.preview,
  });

  final String? main;
  final String? preview;

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      main: json["main"],
      preview: json["preview"],
    );
  }

  @override
  String toString() {
    return "$main, $preview, ";
  }
}
